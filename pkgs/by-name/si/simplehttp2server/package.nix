{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule rec {
  pname = "simplehttp2server";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "GoogleChromeLabs";
    repo = "simplehttp2server";
    rev = version;
    sha256 = "113mcfvy1m91wask5039mhr0187nlw325ac32785yl4bb4igi8aw";
  };

  patches = [
    # Migrate to Go modules
    (fetchpatch {
      url = "https://github.com/GoogleChromeLabs/simplehttp2server/commit/7090b4af33846c48b336335f6a19514b7c1d4392.patch";
      hash = "sha256-xGBPNdAmOAUkr7j2VDfTi3Bm13y/b3nuqDLf1jiGct4=";
    })
  ];

  vendorHash = "sha256-PcDy+46Pz6xOxxwkSjojsbKZyR1yHdbWAJT+HFAEKkA=";
  proxyVendor = true;

  meta = with lib; {
    homepage = "https://github.com/GoogleChromeLabs/simplehttp2server";
    description = "HTTP/2 server for development purposes";
    license = licenses.asl20;
    maintainers = with maintainers; [ yrashk ];
    mainProgram = "simplehttp2server";
  };
}
