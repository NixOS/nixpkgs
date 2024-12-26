{
  buildGoModule,
  fetchFromGitHub,
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
}:

buildGoModule rec {
  pname = "opensnitch";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "opensnitch";
    rev = "refs/tags/v${version}";
    hash = "sha256-pJPpkXRp7cby6Mvc7IzxH9u6MY4PcrRPkimTw3je6iI=";
  };

  postPatch = ''
    # Allow configuring Version at build time
    substituteInPlace daemon/core/version.go --replace "const " "var "
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
    protoc-gen-go-grpc
  ];

  vendorHash = "sha256-urRujxcp58ZuhUtTAqCK0etSZ16YYG/6JY/aOUodl9g=";

  preBuild = ''
    make -C ../proto ../daemon/ui/protocol/ui.pb.go
  '';

  postBuild = ''
    mv $GOPATH/bin/daemon $GOPATH/bin/opensnitchd
    mkdir -p $out/etc/opensnitchd $out/lib/systemd/system
    cp system-fw.json $out/etc/opensnitchd/
    substitute default-config.json $out/etc/opensnitchd/default-config.json \
      --replace "/var/log/opensnitchd.log" "/dev/stdout"
    # Do not mkdir rules path
    sed -i '8d' opensnitchd.service
    # Fixup hardcoded paths
    substitute opensnitchd.service $out/lib/systemd/system/opensnitchd.service \
      --replace "/usr/local/bin/opensnitchd" "$out/bin/opensnitchd"
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/evilsocket/opensnitch/daemon/core.Version=${version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/opensnitchd \
      --prefix PATH : ${lib.makeBinPath [ iptables ]}
  '';

  passthru.tests = {
    inherit (nixosTests) opensnitch;
    version = testers.testVersion {
      package = opensnitch;
      command = "opensnitchd -version";
    };
  };

  meta = with lib; {
    description = "Application firewall";
    mainProgram = "opensnitchd";
    homepage = "https://github.com/evilsocket/opensnitch/wiki";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}
