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
}:

buildGoModule rec {
  pname = "incus-unwrapped";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus";
    rev = "refs/tags/incus-${version}";
    hash = "sha256-WhprzGzTeB8sEMMTYN5j1Zrwg0GiGLlXTqCkcPq0XVo=";
  };

  vendorHash = "sha256-4fxQHtvRULTyKJTGdo42qwWQUSIWqbqOO1Wf8daBP/s=";

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
    installShellCompletion --bash --name incus ./scripts/bash/incus
  '';

  passthru = {
    updateScript = nix-update-script {
       extraArgs = [
        "-vr" "incus-\(.*\)"
       ];
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
