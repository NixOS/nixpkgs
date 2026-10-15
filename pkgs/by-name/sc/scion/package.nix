{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  ciMode ? true, # Override to false to run time-sensitive tests locally
}:
buildGoModule (finalAttrs: {
  pname = "scion";

  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "scionproto";
    repo = "scion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UQgCjX9xYClsBviNwCmxHXAJ7MNce7olpzaCM2ybuc0=";
  };

  __structuredAttrs = true;

  # Tests bind to localhost
  __darwinAllowLocalNetworking = true;

  vendorHash = "sha256-A9K2/bWYUdMA8ypSisxk4NMOavHz51FaHEaxahz+0ek=";

  excludedPackages = [
    "acceptance"
    "demo"
    "tools"
    "private/underlay/ebpf"
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

  # Upstream disables time-sensitive tests and adjusts timeouts in CI
  preCheck = lib.optionalString ciMode ''
    export CI=42
  '';

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
