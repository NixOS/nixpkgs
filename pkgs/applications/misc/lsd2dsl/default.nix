{ lib, stdenv, mkDerivation, fetchFromGitHub
, makeDesktopItem, copyDesktopItems, cmake
, boost, libvorbis, libsndfile, minizip, gtest, qtwebkit }:

mkDerivation rec {
  pname = "lsd2dsl";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "nongeneric";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PLgfsVVrNBTxI4J0ukEOFRoBkbmB55/sLNn5KyiHeAc=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.isLinux copyDesktopItems;

  buildInputs = [ boost libvorbis libsndfile minizip gtest qtwebkit ];

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
    description = "Lingvo dictionaries decompiler";
    longDescription = ''
      A decompiler for ABBYY Lingvo’s proprietary dictionaries.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
