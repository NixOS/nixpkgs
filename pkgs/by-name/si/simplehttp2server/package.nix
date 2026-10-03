{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule (finalAttrs: {
  pname = "simplehttp2server";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "GoogleChromeLabs";
    repo = "simplehttp2server";
    rev = finalAttrs.version;
    hash = "sha256-XKH4IlmLUF/QEYOpIgan9qAAMqxpgDK14iHV4LdjdYQ=";
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

  meta = {
    homepage = "https://github.com/GoogleChromeLabs/simplehttp2server";
    description = "HTTP/2 server for development purposes";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yrashk ];
    mainProgram = "simplehttp2server";
  };
})
