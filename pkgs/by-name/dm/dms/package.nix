{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dms";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "anacrolix";
    repo = "dms";
    rev = "refs/tags/v${version}";
    hash = "sha256-QwRLNCXDu/dKh2o17AyASlVQPIEOX6e4kTINa2ZzZkU=";
  };

  vendorHash = "sha256-Z0DoVmL0zJ4l9hrO+zGp6FcExvhbiPu5+N3Mfyxi5DE=";

  meta = {
    homepage = "https://github.com/anacrolix/dms";
    description = "UPnP DLNA Digital Media Server with basic video transcoding";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.claes ];
    platforms = lib.platforms.linux;
    mainProgram = "dms";
  };
}
