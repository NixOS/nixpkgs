{
  hash,
  lts ? false,
  patches ? [ ],
  nixUpdateExtraArgs ? [ ],
  vendorHash,
  version,
}:

{
  callPackage,
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  acl,
  buildPackages,
  cowsql,
  incus-ui-canonical,
  libcap,
  lxc,
  pkg-config,
  sqlite,
  udev,
  udevCheckHook,
  installShellFiles,
  nix-update-script,
  nixosTests,
}:

let
  pname = "incus${lib.optionalString lts "-lts"}";
  docsPython = buildPackages.python3.withPackages (
    py: with py; [
      furo
      gitpython
      linkify-it-py
      canonical-sphinx-extensions
      myst-parser
      pyspelling
      sphinx
      sphinx-autobuild
      sphinx-copybutton
      sphinx-design
      sphinx-notfound-page
      sphinx-remove-toctrees
      sphinx-reredirects
      sphinx-tabs
      sphinxcontrib-jquery
      sphinxext-opengraph
    ]
  );
in

buildGoModule (finalAttrs: {
  inherit
    pname
    vendorHash
    version
    ;

  outputs = [
    "out"
    "agent_loader"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus";
    tag = "v${version}";
    inherit hash;
  };

  patches = [ ./docs.patch ] ++ patches;

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
    docsPython
    udevCheckHook
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
    # build docs
    mkdir -p .sphinx/deps
    ln -s ${buildPackages.python3.pkgs.swagger-ui-bundle.src} .sphinx/deps/swagger-ui
    substituteInPlace Makefile --replace-fail '. $(SPHINXENV) ; ' ""
    make doc-incremental

    # build multiple binaries of incus-agent
    build_incus_agent() {
      GOOS="$1" GOARCH="$2" CGO_ENABLED=0 \
      go build -ldflags="-s" -tags=agent,netgo \
        -o "$out/share/agent/incus-agent.$1.$3" ./cmd/incus-agent
    }
    ${lib.optionalString stdenv.hostPlatform.isx86_64 ''
      build_incus_agent linux   amd64  x86_64
      build_incus_agent linux   386    i686
      build_incus_agent windows amd64  x86_64
      build_incus_agent windows 386    i686
    ''}
    ${lib.optionalString stdenv.hostPlatform.isAarch64 ''
      build_incus_agent linux   arm64 aarch64
      build_incus_agent windows arm64 aarch64
    ''}

    # build some static executables
    make incus-migrate
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

  doInstallCheck = true;

  postInstall = ''
    installShellCompletion --cmd incus \
      --bash <($out/bin/incus completion bash) \
      --fish <($out/bin/incus completion fish) \
      --zsh <($out/bin/incus completion zsh)

    mkdir -p $agent_loader/bin $agent_loader/etc/systemd/system $agent_loader/lib/udev/rules.d
  ''
  + lib.optionalString (lib.versionOlder finalAttrs.version "6.18") ''
    cp internal/server/instance/drivers/agent-loader/incus-agent{,-setup} $agent_loader/bin/
  ''
  + lib.optionalString (lib.versionAtLeast finalAttrs.version "6.18") ''
    # the agent_loader output is used by virtualisation.incus.agent
    cp internal/server/instance/drivers/agent-loader/incus-agent-linux $agent_loader/bin/incus-agent
    cp internal/server/instance/drivers/agent-loader/incus-agent-setup-linux $agent_loader/bin/incus-agent-setup
  ''
  + ''
    chmod +x $agent_loader/bin/incus-agent{,-setup}
    patchShebangs $agent_loader/bin/incus-agent{,-setup}
    cp internal/server/instance/drivers/agent-loader/systemd/incus-agent.service $agent_loader/etc/systemd/system/
    cp internal/server/instance/drivers/agent-loader/systemd/incus-agent.rules $agent_loader/lib/udev/rules.d/99-incus-agent.rules
    substituteInPlace $agent_loader/etc/systemd/system/incus-agent.service --replace-fail 'TARGET/systemd' "$agent_loader/bin"

    mkdir $doc
    cp -R doc/html $doc/
  '';

  passthru = {
    client = callPackage ./client.nix {
      inherit
        lts
        patches
        vendorHash
        version
        ;
      inherit (finalAttrs) meta src;
    };

    tests = if lts then nixosTests.incus-lts.all else nixosTests.incus.all;

    ui = lib.warnOnInstantiate "`incus.ui` renamed to `incus-ui-canonical`" incus-ui-canonical;

    updateScript = nix-update-script {
      extraArgs = nixUpdateExtraArgs;
    };
  };

  meta = {
    description = "Powerful system container and virtual machine manager";
    homepage = "https://linuxcontainers.org/incus";
    changelog = "https://github.com/lxc/incus/releases/tag/v${version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.lxc ];
    platforms = lib.platforms.linux;
    mainProgram = "incus";
  };
})
