{
  buildGoModule,
  dnsmasq,
  fetchFromGitHub,
  lib,
  nixosTests,
  makeWrapper,
}:

buildGoModule rec {
  pname = "cni-plugin-dnsname";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "dnsname";
    rev = "v${version}";
    sha256 = "090kpq2ppan9ayajdk5vwbvww30nphylgajn2p3441d4jg2nvsm3";
  };

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/dnsname --prefix PATH : ${lib.makeBinPath [ dnsmasq ]}
  '';

  vendorSha256 = null;
  subPackages = [ "plugins/meta/dnsname" ];

  doCheck = false; # NOTE: requires root privileges

  passthru.tests = {
    inherit (nixosTests) podman-dnsname;
  };

  meta = with lib; {
    description = "DNS name resolution for containers";
    homepage = "https://github.com/containers/dnsname";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mikroskeem ];
  };
}
