{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "fast";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "fast";
    tag = "v${version}";
    hash = "sha256-/Li5AAuuHkVqJzmh38g5CPQXWj4RY0TRwvtjlpydosg=";
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
