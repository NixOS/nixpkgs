{ lib, rustPlatform, fetchFromGitHub, shared-mime-info, libiconv, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "handlr-regex";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Anomalocaridid";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ndFe5GlSWVUPdGRRWuImcLtcuOMoMXMyGGIa+CXfCug=";
  };

  cargoHash = "sha256-lCClE8U4188q5rWEEkUt0peLEmYvLoE7vJ6Q9uB5HWg=";

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
