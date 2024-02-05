{
  lts ? false,

  lib,
  buildGoModule,
  fetchFromGitHub,
  writeShellScript,
  acl,
  cowsql,
  hwdata,
  libcap,
  lxc,
  pkg-config,
  sqlite,
  udev,
  installShellFiles,
  nixosTests,
}:

let
  releaseFile = if lts then ./lts.nix else ./latest.nix;
  inherit (import releaseFile) version hash vendorHash;
  name = "incus${lib.optionalString lts "-lts"}";
in

buildGoModule rec {
  pname = "${name}-unwrapped";

  inherit vendorHash version;

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus";
    rev = "v${version}";
    inherit hash;
  };

  postPatch = ''
    substituteInPlace internal/usbid/load.go \
      --replace "/usr/share/misc/usb.ids" "${hwdata}/share/hwdata/usb.ids"
  '';

  excludedPackages = [
    # statically compile these
    "cmd/incus-agent"
    "cmd/incus-migrate"

    # oidc test requires network
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

  ldflags = [
    "-s"
    "-w"
  ];
  tags = [ "libsqlite3" ];

  # required for go-cowsql.
  CGO_LDFLAGS_ALLOW = "(-Wl,-wrap,pthread_create)|(-Wl,-z,now)";

  postBuild = ''
    make incus-agent incus-migrate
  '';

  preCheck =
    let
      skippedTests = [
        "TestValidateConfig"
        "TestConvertNetworkConfig"
        "TestConvertStorageConfig"
        "TestSnapshotCommon"
        "TestContainerTestSuite"
      ];
    in
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

    updateScript = writeShellScript "update-incus" ''
      nix-update ${name}.unwrapped -vr 'v(.*)' --override-filename pkgs/by-name/in/incus/${
        if lts then "lts" else "latest"
      }.nix
    '';
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
