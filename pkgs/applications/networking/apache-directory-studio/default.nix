{ stdenv, fetchurl, xorg, jre, makeWrapper, makeDesktopItem }:

let
  rpath = stdenv.lib.makeLibraryPath (with xorg; [
    libXtst
  ]);

  desktopItem = makeDesktopItem {
    name = "apache-directory-studio";
    exec = "ApacheDirectoryStudio";
    icon = "apache-directory-studio";
    comment = "Eclipse-based LDAP browser and directory client";
    desktopName = "Apache Directory Studio";
    genericName = "Apache Directory Studio";
    categories = "Java;Network";
  };
  version = "2.0.0-M14";
  versionWithDate = "2.0.0.v20180908-M14";
in
stdenv.mkDerivation rec {
  pname = "apache-directory-studio";
  inherit version;

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "mirror://apache/directory/studio/${versionWithDate}/ApacheDirectoryStudio-${versionWithDate}-linux.gtk.x86_64.tar.gz";
        sha256 = "0kq4l3755q69p7bry9xpm5xxw56ksncp76fdqqd1xzbvsg309bps";
      }
    else if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        url = "mirror://apache/directory/studio/${versionWithDate}/ApacheDirectoryStudio-${versionWithDate}-linux.gtk.x86.tar.gz";
        sha256 = "038dy8jjgq5gj5r56y9ps3ycqi9gn57i4q1r3mmjx1b1950wmh1q";
      }
    else throw "Unsupported system: ${stdenv.hostPlatform.system}";

  buildInputs = [ makeWrapper ];

  installPhase = ''
    dest="$out/libexec/ApacheDirectoryStudio"
    mkdir -p "$dest"
    cp -r . "$dest"

    mkdir -p "$out/bin"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        "$dest/ApacheDirectoryStudio"
    makeWrapper "$dest/ApacheDirectoryStudio" \
        "$out/bin/ApacheDirectoryStudio" \
        --prefix PATH : "${jre}/bin" \
        --prefix LD_LIBRARY_PATH : "${rpath}"
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
