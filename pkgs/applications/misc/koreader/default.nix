{ lib, stdenv
, fetchurl
, makeWrapper
<<<<<<< HEAD
, fetchFromGitHub
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, dpkg
, glib
, gnutar
, gtk3-x11
, luajit
, sdcv
<<<<<<< HEAD
, SDL2 }:
let
  luajit_lua52 = luajit.override { enable52Compat = true; };
in
stdenv.mkDerivation rec {
  pname = "koreader";
  version = "2023.04";


  src = if stdenv.isAarch64 then fetchurl {
    url = "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-arm64.deb";
    sha256 = "sha256-uuspjno0750hQMIB5HEhbV63wCna2izKOHEGIg/X0bU=";
  } else fetchurl {
    url = "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-amd64.deb";
    sha256 = "sha256-tRUeRB1+UcWT49dchN0YDvd0L5n1YRdtMSFc8yy6m5o=";
  };

  src_repo = fetchFromGitHub {
    repo = "koreader";
    owner = "koreader";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-c3j6hs0W0H2jDg6JVfU6ov7r7kucbqrQqf9PAvYBcJ0=";
=======
, SDL2
, noto-fonts
, nerdfonts }:
let font-droid = nerdfonts.override { fonts = [ "DroidSansMono" ]; };
in stdenv.mkDerivation rec {
  pname = "koreader";
  version = "2022.08";

  src = fetchurl {
    url =
      "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-amd64.deb";
    sha256 = "sha256-+JBJNJTAnC5gpuo8cehfe/3YwGIW5iFA8bZ8nfz9qsk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  sourceRoot = ".";
  nativeBuildInputs = [ makeWrapper dpkg ];
  buildInputs = [
    glib
    gnutar
    gtk3-x11
<<<<<<< HEAD
    luajit_lua52
=======
    luajit
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sdcv
    SDL2
  ];
  unpackCmd = "dpkg-deb -x ${src} .";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -R usr/* $out/
<<<<<<< HEAD
    ln -sf ${luajit_lua52}/bin/luajit $out/lib/koreader/luajit
    ln -sf ${sdcv}/bin/sdcv $out/lib/koreader/sdcv
    ln -sf ${gnutar}/bin/tar $out/lib/koreader/tar
    find ${src_repo}/resources/fonts -type d -execdir cp -r '{}' $out/lib/koreader/fonts \;
    find $out -xtype l -print -delete
=======
    ln -sf ${luajit}/bin/luajit $out/lib/koreader/luajit
    ln -sf ${sdcv}/bin/sdcv $out/lib/koreader/sdcv
    ln -sf ${gnutar}/bin/tar $out/lib/koreader/tar
    find $out -xtype l -delete
    for i in ${noto-fonts}/share/fonts/truetype/noto/*; do
        ln -s "$i" $out/lib/koreader/fonts/noto/
    done
    ln -s "${font-droid}/share/fonts/opentype/NerdFonts/Droid Sans Mono Nerd Font Complete Mono.otf" $out/lib/koreader/fonts/droid/DroidSansMono.ttf
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    wrapProgram $out/bin/koreader --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [ gtk3-x11 SDL2 glib ]
    }
  '';

  meta = with lib; {
    homepage = "https://github.com/koreader/koreader";
    description =
      "An ebook reader application supporting PDF, DjVu, EPUB, FB2 and many more formats, running on Cervantes, Kindle, Kobo, PocketBook and Android devices";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
<<<<<<< HEAD
    platforms = [ "aarch64-linux" "x86_64-linux" ];
=======
    platforms = intersectLists platforms.x86_64 platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ contrun neonfuz];
  };
}
