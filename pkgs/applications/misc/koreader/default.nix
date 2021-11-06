{ lib, stdenv
, fetchurl
, makeWrapper
, dpkg
, glib
, gnutar
, gtk3-x11
, luajit
, sdcv
, SDL2
, noto-fonts
, nerdfonts }:
let font-droid = nerdfonts.override { fonts = [ "DroidSansMono" ]; };
in stdenv.mkDerivation rec {
  pname = "koreader";
  version = "2021.10.1";

  src = fetchurl {
    url =
      "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-amd64.deb";
    sha256 = "sha256-UpDwexBfjlne/uNMTtNjIyZb3TDMYFeDvtwtTFARovw=";
  };

  sourceRoot = ".";
  nativeBuildInputs = [ makeWrapper dpkg ];
  buildInputs = [
    glib
    gnutar
    gtk3-x11
    luajit
    sdcv
    SDL2
  ];
  unpackCmd = "dpkg-deb -x ${src} .";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -R usr/* $out/
    ln -sf ${luajit}/bin/luajit $out/lib/koreader/luajit
    ln -sf ${sdcv}/bin/sdcv $out/lib/koreader/sdcv
    ln -sf ${gnutar}/bin/tar $out/lib/koreader/tar
    find $out -xtype l -delete
    for i in ${noto-fonts}/share/fonts/truetype/noto/*; do
        ln -s "$i" $out/lib/koreader/fonts/noto/
    done
    ln -s "${font-droid}/share/fonts/opentype/NerdFonts/Droid Sans Mono Nerd Font Complete Mono.otf" $out/lib/koreader/fonts/droid/DroidSansMono.ttf
    wrapProgram $out/bin/koreader --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [ gtk3-x11 SDL2 glib ]
    }
  '';

  meta = with lib; {
    homepage = "https://github.com/koreader/koreader";
    description =
      "An ebook reader application supporting PDF, DjVu, EPUB, FB2 and many more formats, running on Cervantes, Kindle, Kobo, PocketBook and Android devices";
    platforms = intersectLists platforms.x86_64 platforms.linux;
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ contrun neonfuz];
  };
}
