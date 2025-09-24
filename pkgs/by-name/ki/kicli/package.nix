{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "kicli";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "anned20";
    repo = "kicli";
    rev = "v${version}";
    hash = "sha256-NXKo+zK5HnuMXRsi29lEhoo7RCagwvZdXXPNfp4pHtc=";
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
