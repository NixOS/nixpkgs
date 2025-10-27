{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "scion";
  version = "0.12.0-unstable-2025-10-13";

  src = fetchFromGitHub {
    owner = "scionproto";
    repo = "scion";
    rev = "6787965828cd69474da8b8da0473ffe975846bde";
    hash = "sha256-d9pfTIO/7lN6A6UN4zR8uX4kNjDRc4MMzXJKv82d584=";
  };

  vendorHash = "sha256-vD06FX1H2PyjzJ+2WydPiVSXKlP8ylWE4z1DMoiW8SY=";

  excludedPackages = [
    "acceptance"
    "demo"
    "tools"
    "pkg/private/xtest/graphupdater"
    "private/underlay/ebpf"
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

  preCheck = ''
    # Otherwise checks fail with `panic: open /etc/protocols: operation not permitted` when sandboxing is enabled on Darwin
    # https://github.com/NixOS/nixpkgs/pull/381645#issuecomment-2656211797
    substituteInPlace vendor/modernc.org/libc/honnef.co/go/netdb/netdb.go \
      --replace-fail '!os.IsNotExist(err)' '!os.IsNotExist(err) && !os.IsPermission(err)'
  '';

  doCheck = true;

  # Allow network access during tests on Darwin/macOS
  __darwinAllowLocalNetworking = true;

  tags = [ "sqlite_mattn" ];

  passthru = {
    tests = {
      inherit (nixosTests) scion-freestanding-deployment;
    };
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Future Internet architecture utilizing path-aware networking";
    homepage = "https://scion-architecture.net/";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sarcasticadmin
      matthewcroughan
    ];
    teams = with lib.teams; [ ngi ];
  };
})
