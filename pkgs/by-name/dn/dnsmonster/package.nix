{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule rec {
  pname = "dnsmonster";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "mosajjal";
    repo = "dnsmonster";
    tag = "v${version}";
    hash = "sha256-+GFkGUR3XKDgrxVAZ3MuPxGyI0oGROdhHKMBwMSvoBI=";
  };

  vendorHash = "sha256-7rIBbaYr1dgC0ArcuwZelHKG5TLIQDV9JSBoYOcz+C0=";

  buildInputs = [ libpcap ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/mosajjal/dnsmonster/util.releaseVersion=${version}"
  ];

  meta = {
    description = "Passive DNS Capture and Monitoring Toolkit";
    homepage = "https://github.com/mosajjal/dnsmonster";
    changelog = "https://github.com/mosajjal/dnsmonster/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "dnsmonster";
  };
}
