{ lib, stdenv, fetchurl, jdk, makeWrapper, autoPatchelfHook, makeDesktopItem, glib, libsecret, webkitgtk }:

stdenv.mkDerivation rec {
  pname = "apache-directory-studio";
  version = "2.0.0-M17";
  versionWithDate = "2.0.0.v20210717-M17";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "mirror://apache/directory/studio/${versionWithDate}/ApacheDirectoryStudio-${versionWithDate}-linux.gtk.x86_64.tar.gz";
        sha256 = "19zdspzv4n3mfgb1g45s3wh0vbvn6a9zjd4xi5x2afmdjkzlwxi4";
      }
    else throw "Unsupported system: ${stdenv.hostPlatform.system}";

  desktopItem = makeDesktopItem {
    name = "apache-directory-studio";
    exec = "ApacheDirectoryStudio";
    icon = "apache-directory-studio";
    comment = "Eclipse-based LDAP browser and directory client";
    desktopName = "Apache Directory Studio";
    genericName = "Apache Directory Studio";
    categories = [ "Java" "Network" ];
  };

  buildInputs = [ glib libsecret ];
  nativeBuildInputs = [ makeWrapper autoPatchelfHook ];

  installPhase = ''
    dest="$out/libexec/ApacheDirectoryStudio"
    mkdir -p "$dest"
    cp -r . "$dest"

    mkdir -p "$out/bin"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        "$dest/ApacheDirectoryStudio"

    makeWrapper "$dest/ApacheDirectoryStudio" \
        "$out/bin/ApacheDirectoryStudio" \
        --prefix PATH : "${jdk}/bin" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ webkitgtk ])}
    install -D icon.xpm "$out/share/pixmaps/apache-directory-studio.xpm"
    install -D -t "$out/share/applications" ${desktopItem}/share/applications/*
  '';

  meta = with lib; {
    description = "Eclipse-based LDAP browser and directory client";
    homepage = "https://directory.apache.org/studio/";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.asl20;
    # Upstream supports macOS and Windows too.
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "ApacheDirectoryStudio";
  };
}
