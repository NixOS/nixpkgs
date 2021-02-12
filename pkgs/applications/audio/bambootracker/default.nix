{ mkDerivation
, stdenv
, lib
, stdenv
, fetchFromGitHub
, qmake
, pkg-config
, qttools
, qtbase
, alsaSupport ? stdenv.hostPlatform.isLinux
, alsaLib
, pulseSupport ? stdenv.hostPlatform.isLinux
, libpulseaudio
, jackSupport ? stdenv.hostPlatform.isUnix
, jack
, CoreAudio
, CoreMIDI
, CoreFoundation
, CoreServices
}:
let
  inherit (lib) optional optionals;
in
mkDerivation rec {
  pname = "bambootracker";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "rerrahkr";
    repo = "BambooTracker";
    rev = "v${version}";
    sha256 = "1qn4ax9cmmr1slkn83575m9a4wan3r4r6k7cnf4yq2nmh2znpjnh";
    fetchSubmodules = true;
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace BambooTracker/BambooTracker.pro \
      --replace '# Temporary known-error downgrades here' 'CPP_WARNING_FLAGS += -Wno-missing-braces'
  '';

  nativeBuildInputs = [ qmake qttools pkg-config ];

  buildInputs = [ qtbase ]
    ++ optional alsaSupport alsaLib
    ++ optional pulseSupport libpulseaudio
    ++ optional jackSupport jack
    ++ optionals stdenv.hostPlatform.isDarwin [
    CoreAudio
    CoreMIDI
    CoreFoundation
    CoreServices
  ];

  qmakeFlags = optionals alsaSupport [ "CONFIG+=use_alsa" ]
    ++ optionals pulseSupport [ "CONFIG+=use_pulse" ]
    ++ optionals jackSupport [ "CONFIG+=use_jack" ];

  postConfigure = "make qmake_all";

  meta = with lib; {
    description = "A tracker for YM2608 (OPNA) which was used in NEC PC-8801/9801 series computers";
    homepage = "https://rerrahkr.github.io/BambooTracker";
    license = licenses.gpl2Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
    broken = stdenv.isDarwin;
  };
}
