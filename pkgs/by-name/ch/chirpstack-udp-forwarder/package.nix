{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
, protobuf
}: rustPlatform.buildRustPackage rec {
  pname = "chirpstack-udp-forwarder";
  version = "4.1.5";

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-udp-forwarder";
    rev = "81dbf333d7d0fca08e025a2ed801a7592d1cecb8";
    hash = "sha256-JRwWD5TJCibTNRmn69lBPT+aJ/91y92Y7+hbJKxc3BE=";
  };

  cargoHash = "sha256-N5yPQv1mXxSzBOBUZfiIbb7DPiw6ndpFKpTXLd6xPhs=";

  nativeBuildInputs = [
    protobuf
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "UDP packet-forwarder for the ChirpStack Concentratord";
    homepage = "https://www.chirpstack.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ stv0g ];
    platforms = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    mainProgram = "chirpstack-udp-forwarder";
  };
}
