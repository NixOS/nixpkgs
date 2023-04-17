{ lib
, stdenv
, fetchFromGitHub
, cmake
, copyDesktopItems
, boost
, gtest
, libvorbis
, libsndfile
, minizip
, withGUI ? true
, qtwebengine ? null
, wrapQtAppsHook ? null
, makeDesktopItem
}:

assert withGUI -> qtwebengine != null && wrapQtAppsHook != null;

stdenv.mkDerivation rec {
  pname = "lsd2dsl";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "nongeneric";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lzw4WwCguPVStdf2gbphPVqBABfALSCrv/RasbKHhkI=";
  };

  nativeBuildInputs = [ cmake ]
    ++ lib.optional stdenv.isLinux copyDesktopItems
    ++ lib.optional withGUI wrapQtAppsHook;

  buildInputs = [
    boost
    libvorbis
    libsndfile
    minizip
    gtest
  ] ++ lib.optional withGUI qtwebengine;

  dontWrapQtApps = true;

  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-result -Wno-error=missing-braces";

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
    downloadPage = "https://github.com/nongeneric/lsd2dsl/releases";
    description = "Decompiler for ABBYY Lingvo’s and Duden proprietary dictionaries";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
