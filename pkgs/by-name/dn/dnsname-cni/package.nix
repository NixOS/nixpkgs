{
  buildGoModule,
  dnsmasq,
  fetchFromGitHub,
  lib,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "cni-plugin-dnsname";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "dnsname";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-kebN1OLMOrBKBz4aBV0VYm+LmLm6S0mKnVgG2u5I+d4=";
  };

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/dnsname --prefix PATH : ${lib.makeBinPath [ dnsmasq ]}
  '';

  vendorHash = null;
  subPackages = [ "plugins/meta/dnsname" ];

  doCheck = false; # NOTE: requires root privileges

  meta = {
    description = "DNS name resolution for containers";
    mainProgram = "dnsname";
    homepage = "https://github.com/containers/dnsname";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mikroskeem ];
  };
})
