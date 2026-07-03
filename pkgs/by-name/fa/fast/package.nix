{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "fast";
  version = "0-unstable-2026-07-01";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "fast";
    rev = "26d8fc9c189ba748c68f8930af11dee5c2467f7e";
    hash = "sha256-YeDx082+ySqzamo9UutFTXXkrb37nmqt3ZUNzUHShf4=";
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
