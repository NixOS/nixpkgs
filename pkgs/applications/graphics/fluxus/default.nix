{ lib
, stdenv
, fetchFromGitLab
, alsa-lib
, fftw
, freeglut
, freetype
, glew
, libjack2
, libjpeg
, liblo
, libsndfile
, libtiff
, ode
, openal
, openssl
, racket_7_9
, scons
}:
let
  racket = racket_7_9;
in
stdenv.mkDerivation {
  pname = "fluxus";
  version = "0.19";
  src = fetchFromGitLab {
    owner = "nebogeo";
    repo = "fluxus";
    rev = "ba9aee218dd4a9cfab914ad78bdb6d59e9a37400";
    sha256 = "0mwghpgq4n1khwlmgscirhmcdhi6x00c08q4idi2zcqz961bbs28";
  };

  buildInputs = [
    alsa-lib
    fftw
    freeglut.dev
    freetype
    glew
    libjack2
    libjpeg.dev
    liblo
    libsndfile.dev
    libtiff.dev
    ode
    openal
    openssl.dev
    racket_7_9
  ];
  nativeBuildInputs = [ scons ];

  patches = [ ./fix-build.patch ];
  postPatch = ''
    substituteInPlace src/Unicode.cpp \
      --replace "(byte)" "(unsigned char)"
  '';
  sconsFlags = [
    "RacketPrefix=${racket}"
    "RacketInclude=${racket}/include/racket"
    "RacketLib=${racket}/lib/racket"
    "DESTDIR=build"
  ];
  configurePhase = ''
    sconsFlags+=" Prefix=$out"
  '';
  installPhase = ''
    mkdir -p $out
    cp -r build$out/* $out/
  '';

  meta = with lib; {
    description = "Livecoding environment for 3D graphics, sound, and games";
    license = licenses.gpl2;
    homepage = "http://www.pawfal.org/fluxus/";
    maintainers = [ maintainers.brainrape ];
    platforms = platforms.linux;
  };
}
