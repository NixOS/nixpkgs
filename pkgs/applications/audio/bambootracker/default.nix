{ mkDerivation
, stdenv
, fetchFromGitHub
, qmake
, qtbase
, qttools
, alsaSupport ? stdenv.hostPlatform.isLinux
, alsaLib
, pulseSupport ? stdenv.hostPlatform.isLinux
, libpulseaudio
, jackSupport ? stdenv.hostPlatform.isUnix
, libjack2
}:
let

  inherit (stdenv.lib) optional optionals;

in
mkDerivation rec {
  pname = "bambootracker";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "rerrahkr";
    repo = "BambooTracker";
    rev = "v${version}";
    sha256 = "0ibi0sykxf6cp5la2c4pgxf5gvy56yv259fbmdwdrdyv6vlddf42";
  };

  sourceRoot = "source/BambooTracker";

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase ]
    ++ optional alsaSupport alsaLib
    ++ optional pulseSupport libpulseaudio
    ++ optional jackSupport libjack2;

  qmakeFlags = [ "CONFIG+=release" "CONFIG-=debug" ]
    ++ optional pulseSupport "CONFIG+=use_pulse"
    ++ optionals jackSupport [ "CONFIG+=use_jack" "CONFIG+=jack_has_rename" ];

  meta = with stdenv.lib; {
    description = "A tracker for YM2608 (OPNA) which was used in NEC PC-8801/9801 series computers";
    homepage = "https://github.com/rerrahkr/BambooTracker";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
