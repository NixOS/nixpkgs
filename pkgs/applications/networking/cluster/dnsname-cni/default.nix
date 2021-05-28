{ buildGoModule, fetchFromGitHub, lib, dnsmasq }:

buildGoModule rec {
  pname = "cni-plugin-dnsname";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "dnsname";
    rev = "v${version}";
    sha256 = "090kpq2ppan9ayajdk5vwbvww30nphylgajn2p3441d4jg2nvsm3";
  };

  patches = [ ./hardcode-dnsmasq-path.patch ];

  postPatch = ''
    substituteInPlace plugins/meta/dnsname/service.go --replace '@DNSMASQ@' '${dnsmasq}/bin/dnsmasq'
  '';

  vendorSha256 = null;
  subPackages = [ "plugins/meta/dnsname" ];

  doCheck = false; # NOTE: requires root privileges

  meta = with lib; {
    description = "DNS name resolution for containers";
    homepage = "https://github.com/containers/dnsname";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mikroskeem ];
  };
}
