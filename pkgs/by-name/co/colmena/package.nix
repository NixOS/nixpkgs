{
  stdenv,
  lib,
  fetchpatch,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  nix-eval-jobs,
  nix,
  colmena,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "colmena";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "colmena";
    rev = "v${version}";
    sha256 = "sha256-01bfuSY4gnshhtqA1EJCw2CMsKkAx+dHS+sEpQ2+EAQ=";
  };

  cargoHash = "sha256-2OLApLD/04etEeTxv03p0cx8O4O51iGiBQTIG/iOIkU=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  buildInputs = [ nix-eval-jobs ];

  NIX_EVAL_JOBS = "${nix-eval-jobs}/bin/nix-eval-jobs";

  patches = [
    # Fixes nix 2.24 compat: https://github.com/zhaofengli/colmena/pull/236
    (fetchpatch {
      url = "https://github.com/zhaofengli/colmena/commit/36382ee2bef95983848435065f7422500c7923a8.patch";
      sha256 = "sha256-5cQ2u3eTzhzjPN+rc6xWIskHNtheVXXvlSeJ1G/lz+E=";
    })
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd colmena \
      --bash <($out/bin/colmena gen-completions bash) \
      --zsh <($out/bin/colmena gen-completions zsh) \
      --fish <($out/bin/colmena gen-completions fish)

    wrapProgram $out/bin/colmena \
      --prefix PATH ":" "${lib.makeBinPath [ nix ]}"
  '';

  # Recursive Nix is not stable yet
  doCheck = false;

  passthru = {
    # We guarantee CLI and Nix API stability for the same minor version
    apiVersion = builtins.concatStringsSep "." (lib.take 2 (lib.splitVersion version));

    tests.version = testers.testVersion { package = colmena; };
  };

  meta = with lib; {
    description = "Simple, stateless NixOS deployment tool";
    homepage = "https://colmena.cli.rs/${passthru.apiVersion}";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "colmena";
  };
}
