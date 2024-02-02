{ lib
, buildGoModule
, fetchFromGitHub
, acl
, cowsql
, hwdata
, libcap
, lxc
, pkg-config
, sqlite
, udev
, installShellFiles
, nix-update-script
, nixosTests
}:

buildGoModule rec {
  pname = "incus-unwrapped";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus";
    rev = "refs/tags/v${version}";
    hash = "sha256-3eWkQT2P69ZfN62H9B4WLnmlUOGkpzRR0rctgchP+6A=";
  };

  vendorHash = "sha256-2ZJU7WshN4UIbJv55bFeo9qiAQ/wxu182mnz7pE60xA=";

  postPatch = ''
    substituteInPlace internal/usbid/load.go \
      --replace "/usr/share/misc/usb.ids" "${hwdata}/share/hwdata/usb.ids"
  '';

  excludedPackages = [
    "cmd/incus-agent"
    "cmd/incus-migrate"
    "cmd/lxd-to-incus"
    "test/mini-oidc"
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    lxc
    acl
    libcap
    cowsql.dev
    sqlite
    udev.dev
  ];

  ldflags = [ "-s" "-w" ];
  tags = [ "libsqlite3" ];

  # required for go-cowsql.
  CGO_LDFLAGS_ALLOW = "(-Wl,-wrap,pthread_create)|(-Wl,-z,now)";

  postBuild = ''
    make incus-agent incus-migrate
  '';

  preCheck =
    let skippedTests = [
      "TestValidateConfig"
      "TestConvertNetworkConfig"
      "TestConvertStorageConfig"
      "TestSnapshotCommon"
      "TestContainerTestSuite"
    ]; in
    ''
      # Disable tests requiring local operations
      buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
    '';

  postInstall = ''
    # use custom bash completion as it has extra logic for e.g. instance names
    installShellCompletion --bash --name incus ./scripts/bash/incus

    installShellCompletion --cmd incus \
      --fish <($out/bin/incus completion fish) \
      --zsh <($out/bin/incus completion zsh)
  '';


  passthru = {
    tests.incus = nixosTests.incus;

    updateScript = nix-update-script {
       extraArgs = [
        "-vr" "v\(.*\)"
       ];
     };
  };

  meta = {
    description = "Powerful system container and virtual machine manager";
    homepage = "https://linuxcontainers.org/incus";
    changelog = "https://github.com/lxc/incus/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = lib.teams.lxc.members;
    platforms = lib.platforms.linux;
  };
}
