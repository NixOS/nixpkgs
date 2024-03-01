{ lib, stdenv, rustPlatform, fetchFromGitHub, darwin }:

let
  inherit (darwin.apple_sdk.frameworks) Security;
in
rustPlatform.buildRustPackage rec {
  pname = "diswall";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "dis-works";
    repo = "diswall-rs";
    rev = "v${version}";
    sha256 = "sha256-6XMw8fnuM1KyInYCw8DTonsj5gV9d+EuYfO5ggZ3YUU=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  cargoHash = "sha256-So7XBC66y2SKbcjErg4Tnd/NcEpX5zYOEr60RvU9OOU=";

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
    mainProgram = "diswall";
  };
}
