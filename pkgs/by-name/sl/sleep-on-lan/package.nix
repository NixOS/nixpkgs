{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "sleep-on-lan";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "SR-G";
    repo = "sleep-on-lan";
    rev = "${finalAttrs.version}-RELEASE";
    sha256 = "sha256-WooFGIdXIIoJPMqmPpnT+bc+P+IARMSxa3CvXY9++mw=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";
  vendorHash = "sha256-JqDDG53khtDdMLVOscwqi0oGviF+3DMkv5tkHvp1gJc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.BuildVersion=${finalAttrs.version}"
    "-X main.BuildVersionLabel=nixpkgs"
  ];

  meta = {
    homepage = "https://github.com/SR-G/sleep-on-lan";
    description = "Multi-platform process allowing to sleep on LAN a Linux or Windows computer, through wake-on-lan (reversed) magic packets or through HTTP REST requests";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ devusb ];
    mainProgram = "sleep-on-lan";
  };
})
