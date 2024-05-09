{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, callPackage
}:

buildGoModule rec {
  pname = "cloudflared";
  version = "2024.4.1";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cloudflared";
    rev = "refs/tags/${version}";
    hash = "sha256-rDw25kFiD16xma/LozGjlc/Tm6hoRYzHs8spTk6HU6Y=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X github.com/cloudflare/cloudflared/cmd/cloudflared/updater.BuiltForPackageManager=nixpkgs"
  ];

  preCheck = ''
    # Workaround for: sshgen_test.go:74: mkdir /homeless-shelter/.cloudflared: no such file or directory
    export HOME="$(mktemp -d)"

    # Workaround for: protocol_test.go:11:
    #   lookup protocol-v2.argotunnel.com on [::1]:53: read udp [::1]:51876->[::1]:53: read: connection refused
    substituteInPlace "edgediscovery/protocol_test.go" \
      --replace "TestProtocolPercentage" "SkipProtocolPercentage"

    # Workaround for: origin_icmp_proxy_test.go:46:
    #   cannot create ICMPv4 proxy: socket: permission denied nor ICMPv6 proxy: socket: permission denied
    substituteInPlace "ingress/origin_icmp_proxy_test.go" \
      --replace "TestICMPRouterEcho" "SkipICMPRouterEcho"

    # Workaround for: origin_icmp_proxy_test.go:110:
    #   cannot create ICMPv4 proxy: socket: permission denied nor ICMPv6 proxy: socket: permission denied
    substituteInPlace "ingress/origin_icmp_proxy_test.go" \
      --replace "TestConcurrentRequestsToSameDst" "SkipConcurrentRequestsToSameDst"

    # Workaround for: origin_icmp_proxy_test.go:242:
    #   cannot create ICMPv4 proxy: socket: permission denied nor ICMPv6 proxy: socket: permission denied
    substituteInPlace "ingress/origin_icmp_proxy_test.go" \
      --replace "TestICMPRouterRejectNotEcho" "SkipICMPRouterRejectNotEcho"

    # Workaround for: origin_icmp_proxy_test.go:108:
    #   Received unexpected error: cannot create ICMPv4 proxy: Group ID 100 is not between ping group 65534 to 65534 nor ICMPv6 proxy: socket: permission denied
    substituteInPlace "ingress/origin_icmp_proxy_test.go" \
      --replace "TestTraceICMPRouterEcho" "SkipTraceICMPRouterEcho"

    # Workaround for: icmp_posix_test.go:28: socket: permission denied
    substituteInPlace "ingress/icmp_posix_test.go" \
      --replace "TestFunnelIdleTimeout" "SkipFunnelIdleTimeout"

    # Workaround for: icmp_posix_test.go:88: Received unexpected error: Group ID 100 is not between ping group 65534 to 65534
    substituteInPlace "ingress/icmp_posix_test.go" \
      --replace "TestReuseFunnel" "SkipReuseFunnel"

    # Workaround for: manager_test.go:197:
    #   Should be false
    substituteInPlace "datagramsession/manager_test.go" \
      --replace "TestManagerCtxDoneCloseSessions" "SkipManagerCtxDoneCloseSessions"
  '';

  doCheck = !stdenv.isDarwin;

  passthru.tests.simple = callPackage ./tests.nix { inherit version; };

  meta = with lib; {
    description = "Cloudflare Tunnel daemon, Cloudflare Access toolkit, and DNS-over-HTTPS client";
    homepage = "https://www.cloudflare.com/products/tunnel";
    changelog = "https://github.com/cloudflare/cloudflared/releases/tag/${version}";
    license = licenses.asl20;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = with maintainers; [ bbigras enorris thoughtpolice piperswe qjoly ];
    mainProgram = "cloudflared";
  };
}
