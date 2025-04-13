{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  cpp-utilities,
  qtutilities,
  mp4v2,
  libid3tag,
  qtbase,
  qttools,
  qtwebengine,
  qtx11extras,
  tagparser,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "tageditor";
  version = "3.9.5";

  src = fetchFromGitHub {
    owner = "martchus";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Sia6Y/V81WQj4oWjZAAR4o3TngfWq7sWxxiKEuFjQ2M=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    mp4v2
    libid3tag
    qtbase
    qttools
    qtx11extras
    qtwebengine
    cpp-utilities
    qtutilities
    tagparser
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/*.app $out/Applications
    ln -s $out/Applications/tageditor.app/Contents/MacOS/tageditor $out/bin/tageditor
  '';

  meta = with lib; {
    homepage = "https://github.com/Martchus/tageditor";
    description = "Tag editor with Qt GUI and command-line interface supporting MP4/M4A/AAC (iTunes), ID3, Vorbis, Opus, FLAC and Matroska";
    license = licenses.gpl2;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
    mainProgram = "tageditor";
  };
}
