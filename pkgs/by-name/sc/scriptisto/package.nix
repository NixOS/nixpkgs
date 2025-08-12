{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "scriptisto";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "igor-petruk";
    repo = "scriptisto";
    rev = "v${version}";
    hash = "sha256-iaDdOFmi4kfcJSjXOcGAFG9i1SdB+K5Qz4+NDaVQALY=";
  };

  cargoHash = "sha256-20RRmbpJLHbSsa5OBk+IkyzZ4Jnss3nZ9izh7C6gmfI=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage man/*
  '';

  meta = with lib; {
    description = "Language-agnostic \"shebang interpreter\" that enables you to write scripts in compiled languages";
    mainProgram = "scriptisto";
    homepage = "https://github.com/igor-petruk/scriptisto";
    changelog = "https://github.com/igor-petruk/scriptisto/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
