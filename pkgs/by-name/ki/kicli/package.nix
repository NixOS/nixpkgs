{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "kicli";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "anned20";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Mt1lHOC8gBcLQ6kArUvlPrH+Y/63mIQTCsUY2UTJE2c=";
  };

  vendorHash = "sha256-+8L/9NJ3dzP4k+LXkPD208uFGeARv7aT39bhH+R08e0=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/anned20/kicli";
    description = "CLI interface to the Kimai time tracking project";
    license = licenses.mit;
    maintainers = with maintainers; [ poelzi ];
    platforms = platforms.all;
    mainProgram = "kicli";
  };
}
