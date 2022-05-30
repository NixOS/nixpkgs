{ lib, buildGoModule, fetchFromGitHub, stdenv }:

buildGoModule rec {
  pname = "cloudflared";
  version = "2022.7.0";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = version;
    hash   = "sha256-+oacXVDvn9ZxSPPudlF+Tzp0yRmfmFFKL8Hy2AiHqq8=";
  };

  vendorSha256 = null;

  ldflags = [ "-X main.Version=${version}" ];

  preCheck = ''
    # Workaround for: sshgen_test.go:74: mkdir /homeless-shelter/.cloudflared: no such file or directory
    export HOME="$(mktemp -d)";

    # Workaround for: protocol_test.go:11:
    #   lookup protocol-v2.argotunnel.com on [::1]:53: read udp [::1]:51876->[::1]:53: read: connection refused

    substituteInPlace "edgediscovery/protocol_test.go" \
      --replace "TestProtocolPercentage" "SkipProtocolPercentage"

    # disable flaky tests
    substituteInPlace "connection/quic_test.go" \
      --replace "TestServeUDPSession" "SkipServeUDPSession"
  '';

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "CloudFlare Tunnel daemon (and DNS-over-HTTPS client)";
    homepage    = "https://www.cloudflare.com/products/tunnel";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ bbigras enorris thoughtpolice techknowlogick ];
  };
}
