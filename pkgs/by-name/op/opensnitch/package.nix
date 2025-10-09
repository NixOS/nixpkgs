{
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  protobuf,
  go-protobuf,
  pkg-config,
  libnetfilter_queue,
  libnfnetlink,
  lib,
  iptables,
  makeWrapper,
  protoc-gen-go-grpc,
  testers,
  opensnitch,
  nixosTests,
  opensnitch-ui,
  nix-update-script,
}:
let
  # Override protoc-gen-go-grpc to use the compatible version
  # Should be droppable on opensnitch 1.7.0
  protoc-gen-go-grpc' = protoc-gen-go-grpc.overrideAttrs (oldAttrs: rec {
    version = "1.3.0";

    src = fetchFromGitHub {
      owner = "grpc";
      repo = "grpc-go";
      rev = "cmd/protoc-gen-go-grpc/v${version}";
      hash = "sha256-Zy0k5X/KFzCao9xAGt5DNb0MMGEyqmEsDj+uvXI4xH4=";
    };

    vendorHash = "sha256-y+/hjYUTFZuq55YAZ5M4T1cwIR+XFQBmWVE+Cg1Y7PI=";
  });
in
buildGoModule (finalAttrs: {
  pname = "opensnitch";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "opensnitch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XAR7yZjAzbMxIVGSV82agpAGwlejkILGgDI6iRicZuQ=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/evilsocket/opensnitch/pull/1418
      # allow configuring the audit socket path
      url = "https://github.com/evilsocket/opensnitch/commit/f9358a464f204068359bf5174e6ff43288f12c7e.patch?full_index=1";
      hash = "sha256-s9CM1CyGpfJZXEtihXCM7nfPhBY8XuwubynTotqtf3E=";
    })
    (fetchpatch {
      # add missing colon in test definition
      url = "https://github.com/evilsocket/opensnitch/commit/4b38ca1260295d2e0f8c4a7313529f83dcca4554.patch?full_index=1";
      hash = "sha256-/z3iFRpcv75FyarVnpK8/PTU2fcFHS+SNbHn7M5Etk8=";
    })
  ];

  postPatch = ''
    # Allow configuring Version at build time
    substituteInPlace daemon/core/version.go --replace-fail "const " "var "
  '';

  modRoot = "daemon";

  buildInputs = [
    libnetfilter_queue
    libnfnetlink
  ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    go-protobuf
    makeWrapper
    protoc-gen-go-grpc'
  ];

  vendorHash = "sha256-6/N/E+uk6RVmSLy6fSWjHj+J5mPFXtHZwWThhFJnfYY=";

  preBuild = ''
    make -C ../proto ../daemon/ui/protocol/ui.pb.go
  '';

  postBuild = ''
    mv $GOPATH/bin/daemon $GOPATH/bin/opensnitchd
    mkdir -p $out/etc/opensnitchd $out/lib/systemd/system
    cp system-fw.json $out/etc/opensnitchd/
    substitute default-config.json $out/etc/opensnitchd/default-config.json \
      --replace-fail "/var/log/opensnitchd.log" "/dev/stdout"
    # Do not mkdir rules path
    sed -i '8d' opensnitchd.service
    # Fixup hardcoded paths
    substitute opensnitchd.service $out/lib/systemd/system/opensnitchd.service \
      --replace-fail "/usr/local/bin/opensnitchd" "$out/bin/opensnitchd"
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/evilsocket/opensnitch/daemon/core.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/opensnitchd \
      --prefix PATH : ${lib.makeBinPath [ iptables ]}
  '';

  passthru = {
    tests = {
      inherit (nixosTests) opensnitch;
      inherit opensnitch-ui;
      version = testers.testVersion {
        package = opensnitch;
        command = "opensnitchd -version";
      };
    };

    updater = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v([0-9.]+)$"
      ];
    };
  };

  meta = {
    description = "Application firewall";
    mainProgram = "opensnitchd";
    homepage = "https://github.com/evilsocket/opensnitch/wiki";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      onny
      grimmauld
    ];
    platforms = lib.platforms.linux;
  };
})
