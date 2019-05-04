{ stdenv, fetchurl, makeDesktopItem, makeWrapper
, fontconfig, freetype, glib, gtk3
, jdk, libX11, libXrender, libXtst, zlib }:

# The build process is almost like eclipse's.
# See `pkgs/applications/editors/eclipse/*.nix`

stdenv.mkDerivation rec {
  name = "dbeaver-ce-${version}";
  version = "6.0.2";

  desktopItem = makeDesktopItem {
    name = "dbeaver";
    exec = "dbeaver";
    icon = "dbeaver";
    desktopName = "dbeaver";
    comment = "SQL Integrated Development Environment";
    genericName = "SQL Integrated Development Environment";
    categories = "Application;Development;";
  };

  buildInputs = [
    fontconfig freetype glib gtk3
    jdk libX11 libXrender libXtst zlib
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "https://dbeaver.io/files/${version}/dbeaver-ce-${version}-linux.gtk.x86_64.tar.gz";
    sha256 = "12zqz9zi4jryvlk1rjxfl4jdj4a6n00018yyk95glfdrxda2xyib";
  };

  installPhase = ''
    mkdir -p $out/
    cp -r . $out/dbeaver

    # Patch binaries.
    interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)
    patchelf --set-interpreter $interpreter $out/dbeaver/dbeaver

    makeWrapper $out/dbeaver/dbeaver $out/bin/dbeaver \
      --prefix PATH : ${jdk}/bin \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath ([ glib gtk3 libXtst ])} \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"

    # Create desktop item.
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications

    mkdir -p $out/share/pixmaps
    ln -s $out/dbeaver/icon.xpm $out/share/pixmaps/dbeaver.xpm
  '';

  meta = with stdenv.lib; {
    homepage = https://dbeaver.io/;
    description = "Universal SQL Client for developers, DBA and analysts. Supports MySQL, PostgreSQL, MariaDB, SQLite, and more";
    longDescription = ''
      Free multi-platform database tool for developers, SQL programmers, database
      administrators and analysts. Supports all popular databases: MySQL,
      PostgreSQL, MariaDB, SQLite, Oracle, DB2, SQL Server, Sybase, MS Access,
      Teradata, Firebird, Derby, etc.
    '';
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.samueldr ];
  };
}
