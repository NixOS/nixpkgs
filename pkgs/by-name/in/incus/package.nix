{
  lib,
  hwdata,
  pkg-config,
  lxc,
  buildGoModule,
  fetchurl,
  acl,
  libcap,
  cowsql,
  raft-canonical,
  sqlite,
  udev,
  installShellFiles,
  nixosTests,
  gitUpdater,
  callPackage,
}:
buildGoModule rec {
  pname = "incus";
  version = "0.1";

  src = fetchurl {
    url = "https://github.com/lxc/incus/releases/download/incus-${version}/incus-${version}.tar.gz";
    hash = "sha256-dxtvQ442n3Keqqbf2TjxTcyN4J28naI8fIDG0U8CZTs=";
  };

  vendorHash = null;

  postPatch = ''
    substituteInPlace internal/usbid/load.go \
      --replace "/usr/share/misc/usb.ids" "${hwdata}/share/hwdata/usb.ids"
  '';

  excludedPackages = ["test" "incus/internal/server/db/generate" "incus-agent" "incus-migrate" "cmd/lxd-to-incus"];

  nativeBuildInputs = [installShellFiles pkg-config];
  buildInputs = [
    lxc
    acl
    libcap
    cowsql.dev
    raft-canonical.dev
    sqlite
    udev.dev
  ];

  ldflags = ["-s" "-w"];
  tags = ["libsqlite3"];

  # required for go-dqlite. See: https://github.com/canonical/lxd/pull/8939
  preBuild = ''
    export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"
  '';

  # build static binaries: https://github.com/canonical/lxd/blob/6fd175c45e65cd475d198db69d6528e489733e19/Makefile#L43-L51
  postBuild = ''
    make incus-agent incus-migrate
  '';

  preCheck = let
    skippedTests = [
      "TestValidateConfig"
      "TestConvertNetworkConfig"
      "TestConvertStorageConfig"
      "TestSnapshotCommon"
      "TestContainerTestSuite"
    ];
  # Disable tests requiring local operations
  in ''
    buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
  '';

  postInstall = ''
    installShellCompletion --bash --name incus ./scripts/bash/incus
  '';

  meta = with lib; {
    description = "A modern, secure and powerful system container and virtual machine manager.";
    homepage = "https://linuxcontainers.org/incus/introduction/";
    changelog = "https://github.com/lxc/incus/releases/tag/incus-${version}";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ imbearchild ];
    mainProgram = "incus";
    platforms = platforms.linux;
  };
}
