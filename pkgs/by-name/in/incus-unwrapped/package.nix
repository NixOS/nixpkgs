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
, gitUpdater
}:

buildGoModule rec {
  pname = "incus-unwrapped";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus";
    rev = "refs/tags/incus-${version}";
    hash = "sha256-DCNMhfSzIpu5Pdg2TiFQ7GgLEScqt/Xqm2X+VSdeaME=";
  };

  vendorHash = "sha256-Pk0/SfGCqXdXvNHbokSV8ajFHeOv0+Et0JytRCoBLU4=";

  postPatch = ''
    substituteInPlace internal/usbid/load.go \
      --replace "/usr/share/misc/usb.ids" "${hwdata}/share/hwdata/usb.ids"
  '';

  excludedPackages = [
    "cmd/incus-agent"
    "cmd/incus-migrate"
    "cmd/lxd-to-incus"
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

  preBuild = ''
    # required for go-cowsql.
    export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"
  '';

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
    installShellCompletion --bash --name incus ./scripts/bash/incus
  '';

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "incus-";
    };
  };

  meta = {
    description = "Powerful system container and virtual machine manager";
    homepage = "https://linuxcontainers.org/incus";
    changelog = "https://github.com/lxc/incus/releases/tag/incus-${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ adamcstephens ];
    platforms = lib.platforms.linux;
  };
}
