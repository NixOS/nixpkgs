{ lib, stdenv
, fetchurl
, makeWrapper
, fetchFromGitHub
, dpkg
, glib
, gnutar
, gtk3-x11
, luajit
, sdcv
, SDL2 }:
stdenv.mkDerivation rec {
  pname = "koreader";
  version = "2022.08";

  src = fetchurl {
    url =
      "https://github.com/koreader/koreader/releases/download/v${version}/koreader-${version}-amd64.deb";
    sha256 = "sha256-+JBJNJTAnC5gpuo8cehfe/3YwGIW5iFA8bZ8nfz9qsk=";
  };

  src_repo = fetchFromGitHub {
    repo = "koreader";
    owner = "koreader";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-MHQYEzMyZMEQrzR8+Rvci8XjDK2DMUPxjsiWTrrKiAw=";
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
    find ${src_repo}/resources/fonts -type d -execdir cp -r '{}' $out/lib/koreader/fonts \;
    find $out -xtype l -print -delete
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
