{ lib, stdenv
, fetchurl
, makeWrapper
, dpkg
, luajit
, gtk3-x11
, SDL2
, glib
, noto-fonts
, nerdfonts }:
let font-droid = nerdfonts.override { fonts = [ "DroidSansMono" ]; };
in stdenv.mkDerivation rec {
  pname = "koreader";
  version = "2021.01.1";

  src = fetchurl {
    url =
      "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-amd64.deb";
    sha256 = "0kignyia2xrg84bqzsp8rid4c79zg11lhw52z1854jw9v9324pja";
  };

  sourceRoot = ".";
  nativeBuildInputs = [ makeWrapper dpkg ];
  buildInputs = [ luajit gtk3-x11 SDL2 glib ];
  unpackCmd = "dpkg-deb -x ${src} .";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -R usr/* $out/
    cp ${luajit}/bin/luajit $out/lib/koreader/luajit
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
