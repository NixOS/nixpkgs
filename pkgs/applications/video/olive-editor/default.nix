{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, which
, frei0r
, opencolorio
, ffmpeg_4
, CoreFoundation
, cmake
, wrapQtAppsHook
, openimageio
, openexr_3
, portaudio
, imath
, qtwayland
, qtmultimedia
, qttools
}:

stdenv.mkDerivation {
  pname = "olive-editor";
  version = "unstable-2023-03-20";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "olive-editor";
    repo = "olive";
    rev = "8ca16723613517c41304de318169d27c571b90af";
    sha256 = "sha256-lL90+8L7J7pjvhbqfeIVF0WKgl6qQzNun8pL9YPL5Is=";
  };

  cmakeFlags = [
    "-DBUILD_QT6=1"
  ];

  # https://github.com/olive-editor/olive/issues/2200
  patchPhase = ''
    runHook prePatch
    substituteInPlace ./app/node/project/serializer/serializer.h \
      --replace 'QStringRef' 'QStringView'
    substituteInPlace ./app/node/project/serializer/serializer.cpp \
      --replace 'QStringRef' 'QStringView'
    substituteInPlace ./app/node/project/serializer/serializer230220.cpp \
      --replace 'QStringRef' 'QStringView'
    runHook postPatch
  '';

  nativeBuildInputs = [
    pkg-config
    which
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    ffmpeg_4
    frei0r
    opencolorio
    openimageio
    imath
    openexr_3
    portaudio
    qtwayland
    qtmultimedia
    qttools
  ] ++ lib.optional stdenv.isDarwin CoreFoundation;

  meta = with lib; {
    description = "Professional open-source NLE video editor";
    homepage = "https://www.olivevideoeditor.org/";
    downloadPage = "https://www.olivevideoeditor.org/download.php";
    license = licenses.gpl3;
    maintainers = [ maintainers.balsoft ];
    platforms = platforms.unix;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
