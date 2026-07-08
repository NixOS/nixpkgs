{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "fast";
  version = "0-unstable-2026-07-08";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "fast";
    rev = "67b965563bc80f35533ee033a5e4243a40a0b6a7";
    hash = "sha256-1O80kvCndCHwnjsr9HwnWAZJADu7H8JfImyNUVMbDTA=";
  };

  vendorHash = "sha256-YSjJ8NOL97hXZLnfGYIjoKmARv+gWOsv+5qkl9konnA=";

  meta = {
    homepage = "https://github.com/maaslalani/fast";
    description = "Internet speed test in your terminal";
    license = lib.licenses.mit;
    mainProgram = "fast";
    maintainers = with lib.maintainers; [ yarn ];
    platforms = lib.platforms.unix;
  };
}
