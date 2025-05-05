{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage {
  pname = "cliscord";
  version = "0-unstable-2022-10-07";

  src = fetchFromGitHub {
    owner = "somebody1234";
    repo = "cliscord";
    rev = "d62317d55c07ece8c9d042dcd74b62e58c9bfaeb";
    hash = "sha256-dmR49yyErahOUxR9pGW1oYy8Wq5SWOprK317u+JPBv4=";
  };

  buildInputs = [ openssl ];

  nativeBuildInputs = [ pkg-config ];

  cargoHash = "sha256-bJA+vqbhXeygIAg9HWom3xSuPpJgJY5FLb8UMBjrh7U=";

  meta = {
    description = "Simple command-line tool to send text and files to discord";
    homepage = "https://github.com/somebody1234/cliscord";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lom ];
    mainProgram = "cliscord";
  };
}
