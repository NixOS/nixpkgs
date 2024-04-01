{ lib, stdenv, fetchFromGitHub
, makeDesktopItem, copyDesktopItems, cmake
, boost, cups, fmt, libvorbis, libsndfile, minizip, gtest, qt6 }:

stdenv.mkDerivation rec {
  pname = "lsd2dsl";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "nongeneric";
    repo = "lsd2dsl";
    rev = "v${version}";
    hash = "sha256-0UsxDNpuWpBrfjh4q3JhZnOyXhHatSa3t/cApiG2JzM=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "-Werror" ""
  '';

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ] ++ lib.optional stdenv.isLinux copyDesktopItems;

  buildInputs = [
    boost
    cups
    fmt
    libvorbis
    libsndfile
    minizip
    gtest
    qt6.qt5compat
    qt6.qtwebengine
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-int-conversion";

  desktopItems = lib.singleton (makeDesktopItem {
    name = "lsd2dsl";
    exec = "lsd2dsl-qtgui";
    desktopName = "lsd2dsl";
    genericName = "lsd2dsl";
    comment = meta.description;
    categories = [ "Dictionary" "FileTools" "Qt" ];
  });

  installPhase = ''
    install -Dm755 console/lsd2dsl gui/lsd2dsl-qtgui -t $out/bin
  '';

  meta = with lib; {
    homepage = "https://rcebits.com/lsd2dsl/";
    description = "Lingvo dictionaries decompiler";
    longDescription = ''
      A decompiler for ABBYY Lingvo’s proprietary dictionaries.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
