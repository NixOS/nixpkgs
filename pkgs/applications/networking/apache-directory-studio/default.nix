{ stdenv, fetchurl, jdk, makeWrapper, autoPatchelfHook, makeDesktopItem, glib, libsecret }:

let
  desktopItem = makeDesktopItem {
    name = "apache-directory-studio";
    exec = "ApacheDirectoryStudio";
    icon = "apache-directory-studio";
    comment = "Eclipse-based LDAP browser and directory client";
    desktopName = "Apache Directory Studio";
    genericName = "Apache Directory Studio";
    categories = "Java;Network";
  };
  version = "2.0.0-M15";
  versionWithDate = "2.0.0.v20200411-M15";
in
stdenv.mkDerivation rec {
  pname = "apache-directory-studio";
  inherit version;

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "mirror://apache/directory/studio/${versionWithDate}/ApacheDirectoryStudio-${versionWithDate}-linux.gtk.x86_64.tar.gz";
        sha256 = "1rkyb0qcsl9hk2qcwp5mwaab69q3sn77v5xyn9mbvi5wg9icbc37";
      }
    else throw "Unsupported system: ${stdenv.hostPlatform.system}";

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
        --prefix PATH : "${jdk}/bin"
    install -D icon.xpm "$out/share/pixmaps/apache-directory-studio.xpm"
    install -D -t "$out/share/applications" ${desktopItem}/share/applications/*
  '';

  meta = with stdenv.lib; {
    description = "Eclipse-based LDAP browser and directory client";
    homepage = "https://directory.apache.org/studio/";
    license = licenses.asl20;
    # Upstream supports macOS and Windows too.
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
