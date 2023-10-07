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
  version = "unstable-2023-06-12";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "olive-editor";
    repo = "olive";
    rev = "2036fffffd0e24b7458e724b9084ae99c9507c64";
    sha256 = "sha256-qee9/WTvTy5jWLowvZJOwAjrqznRhJR+u9dYsnCN/Qs=";
  };

  cmakeFlags = [
    "-DBUILD_QT6=1"
  ];

  # https://github.com/olive-editor/olive/issues/2200
  patchPhase = ''
    runHook prePatch
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
