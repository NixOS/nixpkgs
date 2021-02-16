{ mkDerivation
, lib
, stdenv
, fetchFromGitHub
, qmake
, pkg-config
, qttools
, qtbase
, rtaudio
, rtmidi
}:

mkDerivation rec {
  pname = "bambootracker";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "rerrahkr";
    repo = "BambooTracker";
    rev = "v${version}";
    sha256 = "0iddqfw951dw9xpl4w7310sl4z544507ppb12i8g4fzvlxfw2ifc";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace BambooTracker/BambooTracker.pro \
      --replace '# Temporary known-error downgrades here' 'CPP_WARNING_FLAGS += -Wno-missing-braces'
  '';

  nativeBuildInputs = [ qmake qttools pkg-config ];

  buildInputs = [ qtbase rtaudio rtmidi ];

  qmakeFlags = [ "CONFIG+=system_rtaudio" "CONFIG+=system_rtmidi" ];

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
