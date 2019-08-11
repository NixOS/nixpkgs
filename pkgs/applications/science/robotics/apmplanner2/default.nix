{ stdenv, fetchFromGitHub, qmake
, qtbase, qtscript, qtwebkit, qtserialport, qtsvg, qtdeclarative, qtquickcontrols2
, alsaLib, libsndfile, flite, openssl, udev, SDL2
}:

stdenv.mkDerivation rec {
  name = "apmplanner2-${version}";
  # TODO revert Qt511 to Qt5 in pkgs/top-level/all-packages.nix on next release
  version = "2.0.27-rc1";
  src = fetchFromGitHub {
    owner = "ArduPilot";
    repo = "apm_planner";
    rev = "${version}";
    sha256 = "1k0786mjzi49nb6yw4chh9l4dmkf9gybpxg9zqkr5yg019nyzcvd";
  };

  qtInputs = [
    qtbase qtscript qtwebkit qtserialport qtsvg qtdeclarative qtquickcontrols2
  ];

  buildInputs = [ alsaLib libsndfile flite openssl udev SDL2 ] ++ qtInputs;
  nativeBuildInputs = [ qmake ];

  qmakeFlags = [ "apm_planner.pro" ];

  # this ugly hack is necessary, as `bin/apmplanner2` needs the contents of `share/APMPlanner2` inside of `bin/`
  preFixup = ''
    ln --relative --symbolic $out/share/APMPlanner2/* $out/bin/
    substituteInPlace $out/share/applications/apmplanner2.desktop \
                      --replace /usr $out
  '';
  
  enableParallelBuilding = true;

  meta = {
    description = "Ground station software for autonomous vehicles";
    longDescription = ''
      A GUI ground control station for autonomous vehicles using the MAVLink protocol.
      Includes support for the APM and PX4 based controllers.
    '';
    homepage = http://ardupilot.org/planner2/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.wucke13 ];
  };
}
