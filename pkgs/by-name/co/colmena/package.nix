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
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "colmena";
  version = "0.4.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "colmena";
    tag = "v${finalAttrs.version}";
    hash = "sha256-01bfuSY4gnshhtqA1EJCw2CMsKkAx+dHS+sEpQ2+EAQ=";
  };

  cargoHash = "sha256-2OLApLD/04etEeTxv03p0cx8O4O51iGiBQTIG/iOIkU=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  buildInputs = [ nix-eval-jobs ];

  env.NIX_EVAL_JOBS = "${nix-eval-jobs}/bin/nix-eval-jobs";

  patches = [
    # Fixes nix 2.24 compat: https://github.com/zhaofengli/colmena/pull/233
    (fetchpatch {
      url = "https://github.com/nix-community/colmena/commit/00fd486d49170b1304c67381b3096e55d4cdc76f.patch";
      hash = "sha256-uwL3u0gO708bzV2NV8sTt10WHaCL3HykJNqSZNp9EtA=";
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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # Recursive Nix is not stable yet
  doCheck = false;

  passthru = {
    # We guarantee CLI and Nix API stability for the same minor version
    apiVersion = builtins.concatStringsSep "." (lib.take 2 (lib.splitVersion finalAttrs.version));
  };

  meta = {
    description = "Simple, stateless NixOS deployment tool";
    homepage = "https://colmena.cli.rs/${finalAttrs.passthru.apiVersion}";
    downloadPage = "https://github.com/nix-community/colmena/";
    changelog = "https://github.com/nix-community/colmena/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zhaofengli ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "colmena";
  };
})
