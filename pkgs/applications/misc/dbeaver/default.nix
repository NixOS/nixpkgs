{ lib
, stdenv
, copyDesktopItems
, fetchFromGitHub
, makeDesktopItem
, makeWrapper
, fontconfig
, freetype
, glib
, gtk3
, jdk17
, libX11
, libXrender
, libXtst
, zlib
, maven
, webkitgtk
, glib-networking
}:

let
  mavenJdk17 = maven.override {
    jdk = jdk17;
  };
in
mavenJdk17.buildMavenPackage rec {
  pname = "dbeaver";
  version = "22.2.2"; # When updating also update mvnHash

  src = fetchFromGitHub {
    owner = "dbeaver";
    repo = "dbeaver";
    rev = version;
    hash = "sha256-TUdtrhQ1JzqZx+QNauNA1P/+WDSSeOGIgGX3SdS0JTI=";
  };

  mvnHash = "sha256-ERZYDsPxp1YXteSmunFIgTGZUYqjZJhqrNytLnIUNBQ=";
  mvnParameters = "-P desktop,all-platforms";

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    fontconfig
    freetype
    glib
    gtk3
    jdk17
    libX11
    libXrender
    libXtst
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    webkitgtk
    glib-networking
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "dbeaver";
      exec = "dbeaver";
      icon = "dbeaver";
      desktopName = "dbeaver";
      comment = "SQL Integrated Development Environment";
      genericName = "SQL Integrated Development Environment";
      categories = [ "Development" ];
    })
  ];

  installPhase =
    let
      productTargetPath = "product/community/target/products/org.jkiss.dbeaver.core.product";

      platformMap = {
        aarch64-darwin = "aarch64";
        aarch64-linux = "aarch64";
        x86_64-darwin = "x86_64";
        x86_64-linux = "x86_64";
      };

      systemPlatform = platformMap.${stdenv.hostPlatform.system} or (throw "dbeaver not supported on ${stdenv.hostPlatform.system}");
    in
    if stdenv.isDarwin then ''
      runHook preInstall

      mkdir -p $out/Applications $out/bin
      cp -r ${productTargetPath}/macosx/cocoa/${systemPlatform}/DBeaver.app $out/Applications

      sed -i "/^-vm/d; /bin\/java/d" $out/Applications/DBeaver.app/Contents/Eclipse/dbeaver.ini

      ln -s $out/Applications/DBeaver.app/Contents/MacOS/dbeaver $out/bin/dbeaver

      wrapProgram $out/Applications/DBeaver.app/Contents/MacOS/dbeaver \
        --prefix JAVA_HOME : ${jdk17.home} \
        --prefix PATH : ${jdk17}/bin

      runHook postInstall
    '' else ''
      runHook preInstall

      mkdir -p $out/
      cp -r ${productTargetPath}/linux/gtk/${systemPlatform}/dbeaver $out/dbeaver

      # Patch binaries.
      interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)
      patchelf --set-interpreter $interpreter $out/dbeaver/dbeaver

      makeWrapper $out/dbeaver/dbeaver $out/bin/dbeaver \
        --prefix PATH : ${jdk17}/bin \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ glib gtk3 libXtst webkitgtk glib-networking ])} \
        --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"

      mkdir -p $out/share/pixmaps
      ln -s $out/dbeaver/icon.xpm $out/share/pixmaps/dbeaver.xpm

      runHook postInstall
    '';

  meta = with lib; {
    homepage = "https://dbeaver.io/";
    description = "Universal SQL Client for developers, DBA and analysts. Supports MySQL, PostgreSQL, MariaDB, SQLite, and more";
    longDescription = ''
      Free multi-platform database tool for developers, SQL programmers, database
      administrators and analysts. Supports all popular databases: MySQL,
      PostgreSQL, MariaDB, SQLite, Oracle, DB2, SQL Server, Sybase, MS Access,
      Teradata, Firebird, Derby, etc.
    '';
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # dependencies from maven
    ];
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    maintainers = with maintainers; [ jojosch mkg20001 ];
    mainProgram = "dbeaver";
  };
}
