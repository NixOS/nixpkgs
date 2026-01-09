{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "authsock-filter";
  version = "0.1.39";

  src = fetchFromGitHub {
    owner = "kawaz";
    repo = "authsock-filter";
    tag = "v${version}";
    hash = "sha256-jr5i25PZZwDwik7EB5Npxe4e6xS7hk8+hMdhFZ1+lGg=";
  };

  cargoHash = "sha256-qTEhsUeWF56ttAuUHaRACT1/Ed4TQBO2DW4cyQuIa4U=";

  meta = {
    description = "SSH agent proxy with filtering and logging";
    homepage = "https://github.com/kawaz/authsock-filter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kawaz ];
    mainProgram = "authsock-filter";
    platforms = lib.platforms.unix;
  };
}
