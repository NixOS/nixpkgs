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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "dnsname";
    rev = "v${version}";
    sha256 = "sha256-hHkQOHDso92gXFCz40iQ7j2cHTEAMsaeW8MCJV2Otqo=";
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
