{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "go-bindata-assetfs";
  version = "1.0.1-unstable-2022-04-12";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "elazarl";
    repo = "go-bindata-assetfs";
    rev = "de3be3ce9537d87338bf26ac211d02d4fa568bb8";
    hash = "sha256-yQgIaTl06nmIu8BfmQzrvEnlPQ2GQ/2nnvTmYXCL1oI=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Serve embedded files from jteeuwen/go-bindata";
    homepage = "https://github.com/elazarl/go-bindata-assetfs";
    mainProgram = "go-bindata-assetfs";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ avnik ];
  };
}
