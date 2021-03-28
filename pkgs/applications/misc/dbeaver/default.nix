{ lib
, stdenv
, fetchFromGitHub
, makeDesktopItem
, makeWrapper
, fontconfig
, freetype
, glib
, gtk3
, jdk
, libX11
, libXrender
, libXtst
, zlib
, maven
}:
let
  desktopItem = makeDesktopItem {
    name = "dbeaver";
    exec = "dbeaver";
    icon = "dbeaver";
    desktopName = "dbeaver";
    comment = "SQL Integrated Development Environment";
    genericName = "SQL Integrated Development Environment";
    categories = "Development;";
  };
in
stdenv.mkDerivation rec {
  pname = "dbeaver-ce";
  version = "21.0.0"; # When updating also update fetchedMavenDeps.sha256

  src = fetchFromGitHub {
    owner = "dbeaver";
    repo = "dbeaver";
    rev = version;
    sha256 = "sha256-it0EcPD7TXSknjVkGv22Nq1D4J32OEncQDy4w9CIPNk=";
  };

  fetchedMavenDeps = stdenv.mkDerivation {
    name = "dbeaver-${version}-maven-deps";
    inherit src;

    buildInputs = [
      maven
    ];

    buildPhase = "mvn package -Dmaven.repo.local=$out/.m2 -P desktop,all-platforms";

    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''
      find $out -type f \
        -name \*.lastUpdated -or \
        -name resolver-status.properties -or \
        -name _remote.repositories \
        -delete
    '';

    # don't do any fixup
    dontFixup = true;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-xKlFFQXd2U513KZKQa7ttSFNX2gxVr9hNsvyaoN/rEE=";
  };

  buildInputs = [
    fontconfig
    freetype
    glib
    gtk3
    jdk
    libX11
    libXrender
    libXtst
    makeWrapper
    zlib
  ];

  nativeBuildInputs = [
    maven
  ];

  buildPhase = ''
    runHook preBuild

    mvn package --offline -Dmaven.repo.local=$(cp -dpR ${fetchedMavenDeps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2 -P desktop,all-platforms

    runHook postBuild
  '';

  installPhase =
    let
      productTargetPath = "product/standalone/target/products/org.jkiss.dbeaver.core.product";

      platformMap = {
        aarch64-linux = "aarch64";
        x86_64-darwin = "x86_64";
        x86_64-linux  = "x86_64";
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
        --prefix JAVA_HOME : ${jdk.home} \
        --prefix PATH : ${jdk}/bin

      runHook postInstall
    '' else ''
      runHook preInstall

      mkdir -p $out/
      cp -r ${productTargetPath}/linux/gtk/${systemPlatform}/dbeaver $out/dbeaver

      # Patch binaries.
      interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)
      patchelf --set-interpreter $interpreter $out/dbeaver/dbeaver

      makeWrapper $out/dbeaver/dbeaver $out/bin/dbeaver \
        --prefix PATH : ${jdk}/bin \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath ([ glib gtk3 libXtst ])} \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"

      # Create desktop item.
      mkdir -p $out/share/applications
      cp ${desktopItem}/share/applications/* $out/share/applications

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
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ];
    maintainers = with maintainers; [ jojosch ];
  };
}
