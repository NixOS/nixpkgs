{ mkDerivation
, stdenv
, fetchFromGitHub
, qmake
, qtbase
, qtmultimedia
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
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "rerrahkr";
    repo = "BambooTracker";
    rev = "v${version}";
    sha256 = "0d0f4jqzknsiq725pvfndarfjg183f92rb0lim3wzshnsixr5vdc";
  };

  sourceRoot = "source/BambooTracker";

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase qtmultimedia ]
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
