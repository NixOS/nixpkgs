{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "dnsmonster";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "mosajjal";
    repo = "dnsmonster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ae7SzImNHOOpaaVLFHdfLrwGhaHkvZBt+s/sRoHYwzk=";
  };

  vendorHash = "sha256-7rIBbaYr1dgC0ArcuwZelHKG5TLIQDV9JSBoYOcz+C0=";

  buildInputs = [ libpcap ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/mosajjal/dnsmonster/util.releaseVersion=${finalAttrs.version}"
  ];

  meta = {
    description = "Passive DNS Capture and Monitoring Toolkit";
    homepage = "https://github.com/mosajjal/dnsmonster";
    changelog = "https://github.com/mosajjal/dnsmonster/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "dnsmonster";
  };
})
