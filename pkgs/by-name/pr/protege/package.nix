{
  lib,
  fetchFromGitHub,
  copyDesktopItems,
  iconConvTools,
  makeDesktopItem,
  makeWrapper,
  jdk11,
  maven,
}:

maven.buildMavenPackage rec {
  pname = "protege";
  version = "5.6.4";

  src = fetchFromGitHub {
    owner = "protegeproject";
    repo = "protege";
    rev = version;
    hash = "sha256-Q3MHa7nCeF31n7JPltcemFBc/sJwGA9Ev0ymjQhY/U0=";
  };

  mvnJdk = jdk11;
  mvnHash = "sha256-kemP2gDv1CYuaoK0fwzBxdLTusarPasf2jCDQj/HPYE=";

  patches = [
    # Pin built-in Maven plugins to avoid checksum variations on Maven updates
    ./enforce-plugin-versions.patch
    # Avoid building platform-dependent builds which embed their own JREs
    ./platform-independent-only.patch
  ];

  nativeBuildInputs = [
    copyDesktopItems
    iconConvTools
    jdk11
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/protege

    # Copy the application directory whole into the output, as it is used by the
    # launcher script as a reference point to look for default configuration
    mv protege-desktop/target/protege-${version}-platform-independent/Protege-${version} $out/Protege

    # Place a wrapper for the launcher script into a default /bin location
    makeWrapper $out/Protege/run.sh $out/bin/protege \
      --set JAVA_HOME ${jdk11.home}

    # Link all jars from within the standard /share/protege directory
    ln -s -t $out/share/protege $out/Protege/bundles/*

    # Generate and copy icons to where they can be found
    icoFileToHiColorTheme $out/Protege/app/Protege.ico protege $out

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Protege Desktop";
      genericName = "Ontology Editor";
      icon = "protege";
      comment = meta.description;
      categories = [ "Development" ];
      exec = "protege";
    })
  ];

  meta = {
    homepage = "https://protege.stanford.edu/";
    downloadPage = "https://protege.stanford.edu/software.php#desktop-protege";
    description = "Free and open-source OWL 2 ontology editor";
    longDescription = ''
      Protégé Desktop is a feature rich ontology editing environment with full
      support for the OWL 2 Web Ontology Language, and direct in-memory
      connections to description logic reasoners.
    '';
    maintainers = with lib.maintainers; [ nessdoor ];
    license = with lib.licenses; [ bsd2 ];
    # TODO Protege is able to run on Darwin as well, but I (@nessdoor) had no
    #      way of testing it nor any experience in packaging Darwin apps, so I
    #      will leave the task to someone who has the right tools and knowledge.
    platforms = lib.platforms.unix;
    mainProgram = "protege";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
}
