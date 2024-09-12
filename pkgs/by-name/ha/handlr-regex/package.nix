{
  lib,
  rustPlatform,
  fetchFromGitHub,
  shared-mime-info,
  libiconv,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "handlr-regex";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "Anomalocaridid";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xYt+pntqfq1RwaLAoTIH6zaJZWgyl58I/2xWCWe+bBs=";
  };

  cargoHash = "sha256-w5eZm+wHx4aU6zsNZhg8mehDSzpd6k6PpV/V7tzukIA=";

  nativeBuildInputs = [
    installShellFiles
    shared-mime-info
  ];

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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Fork of handlr with support for regex";
    homepage = "https://github.com/Anomalocaridid/handlr-regex";
    license = licenses.mit;
    maintainers = with maintainers; [ anomalocaris ];
    mainProgram = "handlr";
  };
}
