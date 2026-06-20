{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule {
  pname = "fastd-exporter";
  version = "0-unstable-2024-04-09";

  src = fetchFromGitHub {
    owner = "freifunk-darmstadt";
    repo = "fastd-exporter";
    rev = "374e4334af6661f4c91a3e83bf7ce071a2a72eca";
    hash = "sha256-0oU4+9G19XP5qtGdcfMz08T04hjcoXX/O+FkaUPxzXE=";
  };

  vendorHash = "sha256-r0W64dct6XWa9sIrzy0UdyoMw+kAq73Qc/QchmsYZkY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Prometheus exporter for fastd";
    homepage = "https://github.com/freifunk-darmstadt/fastd-exporter";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "fastd-exporter";
    maintainers = with lib.maintainers; [
      felixsinger
    ];
  };
}
