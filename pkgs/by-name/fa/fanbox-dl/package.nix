{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "fanbox-dl";
  version = "0.29.2";

  src = fetchFromGitHub {
    owner = "hareku";
    repo = "fanbox-dl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E10X8MJoZFDG9hepPJ8uqxIycpHDqYyIJWCiCW8K3mY=";
  };

  vendorHash = "sha256-kcD4YuI9bh2ipRKRTULOvjqaVZnc4OLpVHX5PtpgO0g=";

  # pings websites during testing
  doCheck = false;

  meta = {
    description = "Pixiv FANBOX Downloader";
    mainProgram = "fanbox-dl";
    homepage = "https://github.com/hareku/fanbox-dl";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.moni ];
  };
})
