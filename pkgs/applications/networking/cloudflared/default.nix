{ lib, buildGoModule, fetchFromGitHub, stdenv }:

buildGoModule rec {
  pname = "cloudflared";
  version = "2022.7.1";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = version;
    hash   = "sha256-kc6+jn4eTCw37u+kPJdx/kxiaj8MnIddDbUFpPfWdlw=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  preCheck = ''
    # Workaround for: sshgen_test.go:74: mkdir /homeless-shelter/.cloudflared: no such file or directory
    export HOME="$(mktemp -d)";

    # Workaround for: protocol_test.go:11:
    #   lookup protocol-v2.argotunnel.com on [::1]:53: read udp [::1]:51876->[::1]:53: read: connection refused

    substituteInPlace "edgediscovery/protocol_test.go" \
      --replace "TestProtocolPercentage" "SkipProtocolPercentage"
  '';

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "CloudFlare Tunnel daemon (and DNS-over-HTTPS client)";
    homepage    = "https://www.cloudflare.com/products/tunnel";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ bbigras enorris thoughtpolice techknowlogick ];
  };
}
