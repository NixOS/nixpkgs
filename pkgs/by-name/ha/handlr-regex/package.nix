{
  lib,
  rustPlatform,
  fetchFromGitHub,
  shared-mime-info,
  libiconv,
  installShellFiles,
  nix-update-script,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "handlr-regex";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "Anomalocaridid";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xjrETTBHqekdPn2NwpGVoRoU8mf0F4jZN2yt0k8ypRA=";
  };

  cargoHash = "sha256-V/daNs2vk2N6N5eUq1haxxuNyGMBLLBSmBx0JozaN5A=";

  nativeBuildInputs = [
    installShellFiles
    shared-mime-info
  ];

  buildInputs = [ libiconv ];

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd handlr \
      --zsh <(COMPLETE=zsh $out/bin/handlr) \
      --bash <(COMPLETE=bash $out/bin/handlr) \
      --fish <(COMPLETE=fish $out/bin/handlr)

    installManPage target/release-tmp/build/handlr-regex-*/out/manual/man1/*
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Fork of handlr with support for regex";
    homepage = "https://github.com/Anomalocaridid/handlr-regex";
    license = licenses.mit;
    maintainers = with maintainers; [ anomalocaris ];
    mainProgram = "handlr";
  };
}
