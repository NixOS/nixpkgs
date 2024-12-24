{
  lib,
  hwdata,
  pkg-config,
  lxc,
  buildGoModule,
  fetchFromGitHub,
  acl,
  libcap,
  dqlite,
  raft-canonical,
  sqlite,
  udev,
  installShellFiles,
  nixosTests,
  nix-update-script,
}:

buildGoModule rec {
  pname = "lxd-unwrapped-lts";
  # major/minor are used in updateScript to pin to LTS
  version = "5.21.2";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "lxd";
    rev = "refs/tags/lxd-${version}";
    hash = "sha256-3C5pLvO7oABWFhFiWtBr5ohFFWm20Gg36WBfVVJgKdc=";
  };

  vendorHash = "sha256-W7+Z2o5cw3u0DbTZA+a3pRXt9zRggUUjFTUTtQ7B22A=";

  postPatch = ''
    substituteInPlace shared/usbid/load.go \
      --replace "/usr/share/misc/usb.ids" "${hwdata}/share/hwdata/usb.ids"
  '';

  excludedPackages = [
    "test"
    "lxd/db/generate"
    "lxd-agent"
    "lxd-migrate"
  ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];
  buildInputs = [
    lxc
    acl
    libcap
    dqlite.dev
    raft-canonical.dev
    sqlite
    udev.dev
  ];

  ldflags = [
    "-s"
    "-w"
  ];
  tags = [ "libsqlite3" ];

  preBuild = ''
    # required for go-dqlite. See: https://github.com/canonical/lxd/pull/8939
    export CGO_LDFLAGS_ALLOW="(-Wl,-wrap,pthread_create)|(-Wl,-z,now)"
  '';

  # build static binaries: https://github.com/canonical/lxd/blob/6fd175c45e65cd475d198db69d6528e489733e19/Makefile#L43-L51
  postBuild = ''
    make lxd-agent lxd-migrate
  '';

  checkFlags =
    let
      skippedTests = [
        "TestValidateConfig"
        "TestConvertNetworkConfig"
        "TestConvertStorageConfig"
        "TestSnapshotCommon"
        "TestContainerTestSuite"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    installShellCompletion --bash --name lxd ./scripts/bash/lxd-client
  '';

  passthru = {
    tests.lxd = nixosTests.lxd;
    tests.lxd-to-incus = nixosTests.incus.lxd-to-incus;

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "lxd-(5.21.*)"
      ];
    };
  };

  meta = with lib; {
    description = "Daemon based on liblxc offering a REST API to manage containers";
    homepage = "https://ubuntu.com/lxd";
    changelog = "https://github.com/canonical/lxd/releases/tag/lxd-${version}";
    license = with licenses; [
      asl20
      agpl3Plus
    ];
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
