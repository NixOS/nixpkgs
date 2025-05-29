{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:
let
  version = "0.11.0";
in

buildGoModule {
  pname = "scion";

  inherit version;

  src = fetchFromGitHub {
    owner = "scionproto";
    repo = "scion";
    rev = "v${version}";
    hash = "sha256-JemqSr1XBwW1hLuWQrApY/hqLj/VpW3xSJedVIoFSiY=";
  };

  vendorHash = "sha256-akFbHgo8xI2/4aQsyutjhXPM5d0A3se3kG/6Ebw1Qcs=";

  excludedPackages = [
    "acceptance"
    "demo"
    "tools"
    "pkg/private/xtest/graphupdater"
  ];

  postInstall = ''
    set +e
    mv $out/bin/gateway $out/bin/scion-ip-gateway
    mv $out/bin/dispatcher $out/bin/scion-dispatcher
    mv $out/bin/router $out/bin/scion-router
    mv $out/bin/control $out/bin/scion-control
    mv $out/bin/daemon $out/bin/scion-daemon
    set -e
  '';

  doCheck = true;

  tags = [ "sqlite_mattn" ];

  passthru.tests = {
    inherit (nixosTests) scion-freestanding-deployment;
  };

  meta = with lib; {
    description = "Future Internet architecture utilizing path-aware networking";
    homepage = "https://scion-architecture.net/";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with maintainers; [
      sarcasticadmin
      matthewcroughan
    ];
  };
}
