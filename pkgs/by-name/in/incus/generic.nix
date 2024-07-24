{
  hash,
  lts ? false,
  patches,
  updateScriptArgs ? "",
  vendorHash,
  version,
}:

{
  callPackage,
  lib,
  buildGoModule,
  fetchFromGitHub,
  writeScript,
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
  pname = "incus${lib.optionalString lts "-lts"}";
in

buildGoModule rec {
  inherit
    patches
    pname
    vendorHash
    version
    ;

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus";
    rev = "refs/tags/v${version}";
    inherit hash;
  };

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

  # Disable tests requiring local operations
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
    installShellCompletion --cmd incus \
      --bash <($out/bin/incus completion bash) \
      --fish <($out/bin/incus completion fish) \
      --zsh <($out/bin/incus completion zsh)
  '';

  passthru = {
    client = callPackage ./client.nix {
      inherit
        lts
        meta
        patches
        src
        vendorHash
        version
        ;
    };

    tests = if lts then nixosTests.incus-lts else nixosTests.incus;

    ui = callPackage ./ui.nix { };

    updateScript = writeScript "ovs-update.nu" ''
      ${./update.nu} ${updateScriptArgs}
    '';
  };

  meta = {
    description = "Powerful system container and virtual machine manager";
    homepage = "https://linuxcontainers.org/incus";
    changelog = "https://github.com/lxc/incus/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = lib.teams.lxc.members;
    platforms = lib.platforms.linux;
    mainProgram = "incus";
  };
}
