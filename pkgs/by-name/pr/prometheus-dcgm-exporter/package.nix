{ lib
, buildGoModule
, fetchFromGitHub
, autoAddDriverRunpath
, dcgm
}:
buildGoModule rec {
  pname = "dcgm-exporter";

  # The first portion of this version string corresponds to a compatible DCGM
  # version.
  version = "3.3.5-3.4.0"; # N.B: If you change this, update dcgm as well to the matching version.

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-IOVPEK+9ogBZJYns2pTyJwHUBMN8JqG1THTJPvpCwdo=";
  };

  CGO_LDFLAGS = "-ldcgm";

  buildInputs = [
    dcgm
  ];

  # gonvml and go-dcgm do not work with ELF BIND_NOW hardening because not all
  # symbols are available on startup.
  hardeningDisable = [ "bindnow" ];

  vendorHash = "sha256-urKa0O8QZnM8cWjPcGVhoAWhx6fCdMmhRX0JOriRaig=";

  nativeBuildInputs = [
    autoAddDriverRunpath
  ];

  # Tests try to interact with running DCGM service.
  doCheck = false;

  postFixup = ''
    patchelf --add-needed libnvidia-ml.so "$out/bin/dcgm-exporter"
  '';

  meta = with lib; {
    description = "NVIDIA GPU metrics exporter for Prometheus leveraging DCGM";
    homepage = "https://github.com/NVIDIA/dcgm-exporter";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
    mainProgram = "dcgm-exporter";
    platforms = platforms.linux;
  };
}
