{ stdenv, lib, config, fetchFromGitHub, cmake, pkg-config
, alsaSupport ? stdenv.isLinux, alsaLib
, pulseSupport ? config.pulseaudio or stdenv.isLinux, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "scream";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "duncanthrax";
    repo = pname;
    rev = version;
    sha256 = "01k2zhfb781gfj3apmcjqbm5m05m6pvnh7fb5k81zwvqibai000v";
  };

  buildInputs = lib.optional pulseSupport libpulseaudio
    ++ lib.optional alsaSupport alsaLib;
  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DPULSEAUDIO_ENABLE=${if pulseSupport then "ON" else "OFF"}"
    "-DALSA_ENABLE=${if alsaSupport then "ON" else "OFF"}"
  ];

  cmakeDir = "../Receivers/unix";

  doInstallCheck = true;
  installCheckPhase = ''
    set +o pipefail

    # Programs exit with code 1 when testing help, so grep for a string
    $out/bin/scream -h 2>&1 | grep -q Usage:
  '';

  meta = with lib; {
    description = "Audio receiver for the Scream virtual network sound card";
    homepage = "https://github.com/duncanthrax/scream";
    license = licenses.mspl;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arcnmx ];
  };
}
