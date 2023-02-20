{ stdenv
, lib
, fetchFromGitLab
, maven
, jdk11
, makeDesktopItem
, makeWrapper
, copyDesktopItems
, wrapGAppsHook
}:

let
  version = "2.4.1";
  src = fetchFromGitLab {
    owner = "filius1";
    repo = "filius";
    rev = "v${version}";
    hash = "sha256-Mgw/qpylZysgfmpWk+iRuQZZrkqXDFfiMHh7jgGbpLA=";
  };
  repository = stdenv.mkDerivation rec {
    pname = "filius-repository";
    inherit version;

    inherit src;

    strictDeps = true;

    nativeBuildInputs = [ maven ];

    buildPhase = ''
      runHook preBuild

      # Skip tests because one test requires an X11 display
      mvn -X clean site install -Dmaven.repo.local=$out -Plinux -DskipTests

      runHook postBuild
    '';

    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''
      runHook preInstall

      find $out -type f \
        -name \*.lastUpdated -or \
        -name resolver-status.properties -or \
        -name _remote.repositories \
        -delete

      runHook postInstall
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-q/Cbyh1MId+POKheTTpcGlDIuuP23Q+6yiPx9I/v7+M=";
  };
in stdenv.mkDerivation rec {
  pname = "filius";
  inherit version;

  /*desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "Filius";
      desktopName = "Filius";
      genericName = "Network simulator";
      comment = meta.description;
      icon = pname;
      exec = pname;
      terminal = false;
      mimeTypes = [ "application/filius-project" ];
      categories = [
        "Education"
        "Network"
        "ComputerScience"
      ];
      startupNotify = false;
      extraConfig = {
        "GenericName[en]" = "Network simulator";
        "GenericName[de]" = "Netzwerksimulator";
        "Comment[en]" = meta.description;
        "Comment[de]" = "Ein Netzwerksimulator für Bildungszwecke";
      };
    })
  ];*/

  inherit src;

  strictDeps = true;

  nativeBuildInputs = [ maven makeWrapper copyDesktopItems wrapGAppsHook ];

  postPatch = ''
    substituteInPlace pom.xml --replace '/usr' "$out/share"
  '';

  buildPhase = ''
    echo "Using repository ${repository}"
    mvn -X clean site install --offline -Dmaven.repo.local=${repository} -Plinux -DskipTests;
  '';

  installPhase = ''
    runHook preInstall

    ls -al target

    #install -d $out/bin $out/share/mime/packages

    #classpath=$(find ${repository} -name "*.jar" -printf ':%h/%f');
    #install -D target/${pname}.jar -t $out/share/${pname}
    #makeWrapper ${jdk11}/bin/java $out/bin/${pname} \
    #  --add-flags "-classpath $out/share/${pname}/${pname}.jar:''${classpath#:}" \
    #  --add-flags "${pname}.Main"

    #cp -r src/main/resources/* $out/share/${pname}/

    #install -D src/deb/application-filius-project.xml $out/share/mime/packages/${pname}.xml

    #install -D src/deb/${pname}32.png $out/share/icons/hicolor/80x56/apps/${pname}.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "A network simulator for educational purpose";
    homepage = "https://www.lernsoftware-filius.de";
    license = with licenses; [ gpl2Only gpl3Only ];
    platforms = platforms.all;
    maintainers = with maintainers; [ annaaurora ];
  };
}
