{ lib, stdenv, rustPlatform, fetchFromGitHub, darwin }:

let
  inherit (darwin.apple_sdk.frameworks) Security;
in
rustPlatform.buildRustPackage rec {
  pname = "diswall";
<<<<<<< HEAD
  version = "0.4.2";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dis-works";
    repo = "diswall-rs";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-uWGpSpT8TyEkF5OI2enZwbcsyoHIemC0Dm1LExi+AC8=";
=======
    sha256 = "sha256-g5KhJlkW32b2g2ZtpYd/52TTmCezxAT5SavvgXYEJoE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

<<<<<<< HEAD
  cargoHash = "sha256-Te2mqrBKHDKbFaO0ZNV2C6AHz07v1jWCMm05YiXg+w0=";
=======
  cargoHash = "sha256-SnYNp+iWqDPi2kdM3qzGIj6jsWgl0pj0x9f3gd7lbpA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
