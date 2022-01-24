{ stdenv, lib, config, fetchFromGitHub, cmake, pkg-config
, alsaSupport ? stdenv.isLinux, alsa-lib
, pulseSupport ? config.pulseaudio or stdenv.isLinux, libpulseaudio
, jackSupport ? false, libjack2
}:

stdenv.mkDerivation rec {
  pname = "scream";
  version = "3.9";

  src = fetchFromGitHub {
    owner = "duncanthrax";
    repo = pname;
    rev = version;
    sha256 = "sha256-JxDR7UhS4/+oGQ9Fwm4f+yBM9OyX0Srvr9n/vaZVvxQ=";
  };

  buildInputs = lib.optional pulseSupport libpulseaudio
    ++ lib.optional jackSupport libjack2
    ++ lib.optional alsaSupport alsa-lib;
  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DPULSEAUDIO_ENABLE=${if pulseSupport then "ON" else "OFF"}"
    "-DALSA_ENABLE=${if alsaSupport then "ON" else "OFF"}"
    "-DJACK_ENABLE=${if jackSupport then "ON" else "OFF"}"
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
