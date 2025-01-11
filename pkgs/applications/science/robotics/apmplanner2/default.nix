{
  lib,
  mkDerivation,
  fetchFromGitHub,
  qmake,
  qtbase,
  qtscript,
  qtwebkit,
  qtserialport,
  qtsvg,
  qtdeclarative,
  qtquickcontrols2,
  alsa-lib,
  libsndfile,
  flite,
  openssl,
  udev,
  SDL2,
}:

mkDerivation rec {
  pname = "apmplanner2";
  version = "2.0.28";

  src = fetchFromGitHub {
    owner = "ArduPilot";
    repo = "apm_planner";
    rev = version;
    sha256 = "0wvbfjnnf7sh6fpgw8gimh5hgzywj3nwrgr80r782f5gayd3v2l1";
  };

  buildInputs = [
    alsa-lib
    libsndfile
    flite
    openssl
    udev
    SDL2
    qtbase
    qtscript
    qtwebkit
    qtserialport
    qtsvg
    qtdeclarative
    qtquickcontrols2
  ];

  nativeBuildInputs = [ qmake ];

  qmakeFlags = [ "apm_planner.pro" ];

  # this ugly hack is necessary, as `bin/apmplanner2` needs the contents of `share/APMPlanner2` inside of `bin/`
  preFixup = ''
    ln --relative --symbolic $out/share/APMPlanner2/* $out/bin/
    substituteInPlace $out/share/applications/apmplanner2.desktop \
      --replace /usr $out
  '';

  meta = {
    description = "Ground station software for autonomous vehicles";
    longDescription = ''
      A GUI ground control station for autonomous vehicles using the MAVLink protocol.
      Includes support for the APM and PX4 based controllers.
    '';
    homepage = "https://ardupilot.org/planner2/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ wucke13 ];
  };
}
