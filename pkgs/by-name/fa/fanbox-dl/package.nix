{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "fanbox-dl";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "hareku";
    repo = "fanbox-dl";
    rev = "v${version}";
    hash = "sha256-yrSA9CavQgu89hl+x578geC35KvamfAPOSg33woVI8w=";
  };

  vendorHash = "sha256-uhNitrJeFuFG2XyQrc1JBbExoU6Ln6AFRO2Bgb1+N5M=";

  # pings websites during testing
  doCheck = false;

  meta = with lib; {
    description = "Pixiv FANBOX Downloader";
    mainProgram = "fanbox-dl";
    homepage = "https://github.com/hareku/fanbox-dl";
    license = licenses.mit;
    maintainers = [ maintainers.moni ];
  };
}
