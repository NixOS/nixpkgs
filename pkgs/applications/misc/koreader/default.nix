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
let
  font-droid = nerdfonts.override { fonts = [ "DroidSansMono" ]; };

  patchedLuajit = luajit.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      (fetchurl {
        url = "https://github.com/koreader/koreader-base/raw/4216c40d662660c9bbc48e79893b437e97518254/thirdparty/luajit/koreader-luajit-enable-table_pack.patch";
        hash = "sha256-SKaKsb8AHW82KXPErep6+/RZ+d9WPX2ULZPowgkmmQM=";
      })
    ];
  });
in stdenv.mkDerivation rec {
  pname = "koreader";
  version = "2023.04";

  src = fetchurl {
    url =
      "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-amd64.deb";
    sha256 = "sha256-tRUeRB1+UcWT49dchN0YDvd0L5n1YRdtMSFc8yy6m5o=";
  };

  sourceRoot = ".";
  nativeBuildInputs = [ makeWrapper dpkg ];
  buildInputs = [
    glib
    gnutar
    gtk3-x11
    patchedLuajit
    sdcv
    SDL2
  ];
  unpackCmd = "dpkg-deb -x ${src} .";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -R usr/* $out/
    ln -sf ${patchedLuajit}/bin/luajit $out/lib/koreader/luajit
    ln -sf ${sdcv}/bin/sdcv $out/lib/koreader/sdcv
    ln -sf ${gnutar}/bin/tar $out/lib/koreader/tar
    find $out -xtype l -delete
    # TODO: fix font file names either here or in font.lua
    # for i in ${noto-fonts}/share/fonts/truetype/*ttf; do
    #     ln -s "$i" $out/lib/koreader/fonts/noto/
    # done

    ln -s "${noto-fonts}/share/fonts/noto/NotoSans[wdth,wght].ttf" $out/lib/koreader/fonts/noto/NotoSans-Regular.ttf
    ln -s "${noto-fonts}/share/fonts/noto/NotoSans[wdth,wght].ttf" $out/lib/koreader/fonts/noto/NotoSans-Bold.ttf
    ln -s "${noto-fonts}/share/fonts/noto/NotoSans-Italic[wdth,wght].ttf" $out/lib/koreader/fonts/noto/NotoSans-Italic.ttf
    ln -s "${noto-fonts}/share/fonts/noto/NotoNaskhArabicUI[wght].ttf" $out/lib/koreader/fonts/noto/NotoSansArabicUI-Regular.ttf
    ln -s "${noto-fonts}/share/fonts/noto/NotoSansDevanagari[wdth,wght].ttf" $out/lib/koreader/fonts/noto/NotoSansDevanagariUI-Regular.ttf
    ln -s "${noto-fonts}/share/fonts/noto/NotoSansBengali[wdth,wght].ttf" $out/lib/koreader/fonts/noto/NotoSansBengaliUI-Regular.ttf

    ln -s "${font-droid}/share/fonts/opentype/NerdFonts/DroidSansMNerdFontMono-Regular.otf" $out/lib/koreader/fonts/droid/DroidSansMono.ttf
    wrapProgram $out/bin/koreader --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [ gtk3-x11 SDL2 glib ]
    }
  '';

  meta = with lib; {
    homepage = "https://github.com/koreader/koreader";
    description =
      "An ebook reader application supporting PDF, DjVu, EPUB, FB2 and many more formats, running on Cervantes, Kindle, Kobo, PocketBook and Android devices";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = intersectLists platforms.x86_64 platforms.linux;
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ contrun neonfuz];
  };
}
