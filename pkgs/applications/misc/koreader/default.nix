{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  fetchFromGitHub,
  dpkg,
  glib,
  gnutar,
  gtk3-x11,
  luajit,
  sdcv,
  SDL2,
}:
let
  luajit_lua52 = luajit.override { enable52Compat = true; };
in
stdenv.mkDerivation rec {
  pname = "koreader";
  version = "2024.03.1";

  src =
    if stdenv.isAarch64 then
      fetchurl {
        url = "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-arm64.deb";
        hash = "sha256-9Bu+mWfJuPaH5nV71JMrcGipiZWfcf19KfVauCW92+I=";
      }
    else
      fetchurl {
        url = "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-amd64.deb";
        hash = "sha256-EZ3iqp0A2BZwI343nvvp71RGQx6FPesUBy4Lha4Yz4U=";
      };

  src_repo = fetchFromGitHub {
    repo = "koreader";
    owner = "koreader";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-gHn1xqBc7M9wkek1Ja1gry8TKIuUxQP8T45x3z2S4uc=";
  };

  sourceRoot = ".";
  nativeBuildInputs = [
    makeWrapper
    dpkg
  ];
  buildInputs = [
    glib
    gnutar
    gtk3-x11
    luajit_lua52
    sdcv
    SDL2
  ];
  unpackCmd = "dpkg-deb -x ${src} .";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -R usr/* $out/
    ln -sf ${luajit_lua52}/bin/luajit $out/lib/koreader/luajit
    ln -sf ${sdcv}/bin/sdcv $out/lib/koreader/sdcv
    ln -sf ${gnutar}/bin/tar $out/lib/koreader/tar
    find ${src_repo}/resources/fonts -type d -execdir cp -r '{}' $out/lib/koreader/fonts \;
    find $out -xtype l -print -delete
    wrapProgram $out/bin/koreader --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        gtk3-x11
        SDL2
        glib
      ]
    }
  '';

  meta = with lib; {
    homepage = "https://github.com/koreader/koreader";
    description = "An ebook reader application supporting PDF, DjVu, EPUB, FB2 and many more formats, running on Cervantes, Kindle, Kobo, PocketBook and Android devices";
    mainProgram = "koreader";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      contrun
      neonfuz
    ];
  };
}
