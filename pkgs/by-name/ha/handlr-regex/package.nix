{ lib, rustPlatform, fetchFromGitHub, shared-mime-info, libiconv, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "handlr-regex";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "Anomalocaridid";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RCMTRf/mrLCDrmJSAofTgCHKK4GogkdGXnN4lFFQMA8=";
  };

  cargoHash = "sha256-GHRryBeofZQbVTyOwMwYKVAymui8VvsUQhiwGu0+HEE=";

  nativeBuildInputs = [ installShellFiles shared-mime-info ];
  buildInputs = [ libiconv ];

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  postInstall = ''
    installShellCompletion \
      --zsh assets/completions/_handlr \
      --bash assets/completions/handlr \
      --fish assets/completions/handlr.fish

    installManPage assets/manual/man1/*
  '';

  meta = with lib; {
    description = "Fork of handlr with support for regex";
    homepage = "https://github.com/Anomalocaridid/handlr-regex";
    license = licenses.mit;
    maintainers = with maintainers; [ anomalocaris ];
    mainProgram = "handlr";
  };
}
