{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  gitUpdater,
}:

buildGoModule rec {
  pname = "cloudflared";
  version = "2025.11.1";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cloudflared";
    tag = version;
    hash = "sha256-OspDwmh8rzGaHlLfQiUxQzDNxBdzkBJbPrmL1YN7BtM=";
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
      --replace-warn "TestProtocolPercentage" "SkipProtocolPercentage"

    # Workaround for: origin_icmp_proxy_test.go:46:
    #   cannot create ICMPv4 proxy: socket: permission denied nor ICMPv6 proxy: socket: permission denied
    substituteInPlace "ingress/origin_icmp_proxy_test.go" \
      --replace-warn "TestICMPRouterEcho" "SkipICMPRouterEcho"

    # Workaround for: origin_icmp_proxy_test.go:110:
    #   cannot create ICMPv4 proxy: socket: permission denied nor ICMPv6 proxy: socket: permission denied
    substituteInPlace "ingress/origin_icmp_proxy_test.go" \
      --replace-warn "TestConcurrentRequestsToSameDst" "SkipConcurrentRequestsToSameDst"

    # Workaround for: origin_icmp_proxy_test.go:242:
    #   cannot create ICMPv4 proxy: socket: permission denied nor ICMPv6 proxy: socket: permission denied
    substituteInPlace "ingress/origin_icmp_proxy_test.go" \
      --replace-warn "TestICMPRouterRejectNotEcho" "SkipICMPRouterRejectNotEcho"

    # Workaround for: origin_icmp_proxy_test.go:108:
    #   Received unexpected error: cannot create ICMPv4 proxy: Group ID 100 is not between ping group 65534 to 65534 nor ICMPv6 proxy: socket: permission denied
    substituteInPlace "ingress/origin_icmp_proxy_test.go" \
      --replace-warn "TestTraceICMPRouterEcho" "SkipTraceICMPRouterEcho"

    # Workaround for: icmp_posix_test.go:28: socket: permission denied
    substituteInPlace "ingress/icmp_posix_test.go" \
      --replace-warn "TestFunnelIdleTimeout" "SkipFunnelIdleTimeout"

    # Workaround for: icmp_posix_test.go:88: Received unexpected error: Group ID 100 is not between ping group 65534 to 65534
    substituteInPlace "ingress/icmp_posix_test.go" \
      --replace-warn "TestReuseFunnel" "SkipReuseFunnel"

    # Workaround for: manager_test.go:197:
    #   Should be false
    substituteInPlace "datagramsession/manager_test.go" \
      --replace-warn "TestManagerCtxDoneCloseSessions" "SkipManagerCtxDoneCloseSessions"
  '';

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    tests = callPackage ./tests.nix { inherit version; };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Client for various Cloudflare services, including Tunnel, Access, and DNS over HTTPS";
    longDescription = ''
      Contains the command-line client for Cloudflare Tunnel, a tunneling daemon that proxies traffic from the Cloudflare network to your origins.
      This daemon sits between Cloudflare network and your origin (e.g. a webserver). Cloudflare attracts client requests and sends them to you
      via this daemon, without requiring you to poke holes on your firewall --- your origin can remain as closed as possible.
      Extensive documentation can be found in the [Cloudflare Tunnel section](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel) of the Cloudflare Docs.
      All usages related with proxying to your origins are available under `cloudflared tunnel help`.

      You can also use `cloudflared` to access Tunnel origins (that are protected with `cloudflared tunnel`) for TCP traffic
      at Layer 4 (i.e., not HTTP/websocket), which is relevant for use cases such as SSH, RDP, etc.
      Such usages are available under `cloudflared access help`.

      You can instead use [WARP client](https://developers.cloudflare.com/cloudflare-one/team-and-resources/devices/warp/) (`pkgs.cloudflare-warp` or `services.cloudflare-warp` on NixOS)
      to access private origins behind Tunnels for Layer 4 traffic without requiring `cloudflared access` commands on the client side.
    '';
    homepage = "https://www.cloudflare.com/products/tunnel";
    downloadPage = "https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/downloads/";
    changelog = "https://raw.githubusercontent.com/cloudflare/cloudflared/refs/tags/${version}/RELEASE_NOTES";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [
      bbigras
      enorris
      thoughtpolice
      piperswe
      qjoly
      wrbbz
    ];
    mainProgram = "cloudflared";
  };
}
