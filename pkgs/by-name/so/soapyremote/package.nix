{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  soapysdr,
  avahi,
}:

let
  version = "0.5.2-unstable-2024-01-24";

in
stdenv.mkDerivation {
  pname = "soapyremote";
  inherit version;

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyRemote";
    rev = "54caa5b2af348906607c5516a112057650d0873d";
    sha256 = "sha256-uekElbcbX2P5TEufWEoP6tgUM/4vxgSQZu8qaBCSo18=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    soapysdr
    avahi
  ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [ "-include sys/select.h" ]
  );

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapyRemote";
    description = "SoapySDR plugin for remote access to SDRs";
    license = licenses.boost;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.unix;
    mainProgram = "SoapySDRServer";
  };
}
