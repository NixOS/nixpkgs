{ lib
, fetchFromGitHub
, stdenv
, makeWrapper
, curl
, dnsutils
, jq
, gawk
}:

stdenv.mkDerivation (self: {
  pname = "hetzner-api-dyndns";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "FarrowStrange";
    repo = self.pname;
    rev = "v${self.version}";
    hash = "sha256-8YROWePYAQ/R+C9MwxqiJm++du9WhbmlPMnU7ByyP5w=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin;
    cp dyndns.sh $out/bin/hetzner-dyndns
    chmod +x $out/bin/hetzner-dyndns
  '';

  postFixup = ''
    wrapProgram $out/bin/hetzner-dyndns --prefix PATH : ${lib.makeBinPath [ curl dnsutils jq gawk ]}
  '';

  meta = with lib; {
    description = "small script to dynamically update DNS records using the Hetzner DNS-API";
    homepage = "https://github.com/FarrowStrange/hetzner-api-dyndns";
    changelog = "https://github.com/FarrowStrange/hetzner-api-dyndns/releases/tag/v${self.version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ e1mo];
    platforms = platforms.unix;
    mainProgram = "hetzner-dyndns";
  };
})
