{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "scion";

  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "scionproto";
    repo = "scion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J51GIQQhS623wFUU5dI/TwT2rkDH69518lpdCLZ/iM0=";
  };

  vendorHash = "sha256-Ew/hQM8uhaM89sCcPKUBbiGukDq3h5x+KID3w/8BDHg=";

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

  passthru = {
    tests = {
      inherit (nixosTests) scion-freestanding-deployment;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Future Internet architecture utilizing path-aware networking";
    homepage = "https://www.scion.org/";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sarcasticadmin
      matthewcroughan
    ];
    teams = with lib.teams; [ ngi ];
  };
})
