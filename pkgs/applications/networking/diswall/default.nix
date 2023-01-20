{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "diswall";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "dis-works";
    repo = "diswall-rs";
    rev = "v${version}";
    sha256 = "sha256-3FTqT3IL48lYmGoB9u76RQSgZPbaq7IkOyQjyxwpkWA=";
  };

  cargoHash = "sha256-sb6s4Oc3W+I9DB0SGyZINxyWHCSpkakiEeQUatEpeEU=";

  doCheck = false;

  meta = with lib; {
    description = "Distributed firewall";
    longDescription = ''
      Diswall (distributed firewall) - a client of distributed firewall
      working on many servers and using NATS for the transport level.
      Its purpose - blocking IPs with a blink of the eye on all servers
      in any infrastructure when some IP checks any of the closed ports
      of anyone of these servers. Therefore, diswall provides good
      protection of whole infrastructure (as anti-shodan) preventing
      intruder to get any system information.
    '';
    homepage = "https://www.diswall.stream";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ izorkin ];
  };
}
