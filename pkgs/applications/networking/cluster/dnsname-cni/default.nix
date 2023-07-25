{
  buildGoModule,
  dnsmasq,
  fetchFromGitHub,
  lib,
  makeWrapper,
}:

buildGoModule rec {
  pname = "cni-plugin-dnsname";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "dnsname";
    rev = "v${version}";
    sha256 = "sha256-kebN1OLMOrBKBz4aBV0VYm+LmLm6S0mKnVgG2u5I+d4=";
  };

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/dnsname --prefix PATH : ${lib.makeBinPath [ dnsmasq ]}
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
