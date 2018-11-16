{ stdenv, fetchFromGitHub, qmake
, qtbase, qtscript, qtwebkit, qtserialport, qtsvg, qtdeclarative, qtquickcontrols2
, alsaLib, libsndfile, flite, openssl, udev, SDL2
}:

stdenv.mkDerivation rec {
  name = "apmplanner2-${version}";
  version = "2.0.26";
  src = fetchFromGitHub {
    owner = "ArduPilot";
    repo = "apm_planner";
    rev = "${version}";
    sha256 = "0bnyi1r8k8ij5sq2zqv7mfbrxm0xdw97qrx3sk4rinqv2g6h6di4";
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
