{
  lib,
  fetchFromGitHub,
  fetchurl,
  copyDesktopItems,
  iconConvTools,
  makeDesktopItem,
  makeWrapper,
  jdk11,
  maven,
}:

let

  hermitPlugin = fetchurl {
    url = "https://repo1.maven.org/maven2/net/sourceforge/owlapi/org.semanticweb.hermit/1.4.3.456/org.semanticweb.hermit-1.4.3.456.jar";
    hash = "sha256-SkAqPW81xXstxnIo2z23d1uwJ7RQKby67DLmyQfjpAk=";
  };

  dlQueryPlugin = fetchurl {
    url = "https://repo1.maven.org/maven2/edu/stanford/protege/org.coode.dlquery/4.0.1/org.coode.dlquery-4.0.1.jar";
    hash = "sha256-BaY0ZYuDm+c+RO193Iy8rhcZXDBBwFqbe8NaKn1KonE=";
  };

  owlVizPlugin = fetchurl {
    url = "https://repo1.maven.org/maven2/edu/stanford/protege/owlviz/5.0.3/owlviz-5.0.3.jar";
    hash = "sha256-xdC0dOh+iujno+jotJ6zUtJyvWAD+5jfeB0AZCdOyZ0=";
  };

  rdfLibraryPlugin = fetchurl {
    url = "https://repo1.maven.org/maven2/edu/stanford/protege/rdf-library/3.0.0/rdf-library-3.0.0.jar";
    hash = "sha256-PXTiADvDRt4ZPiu9kPi4Zl5fc+guHvyNDnnlFRGMgoQ=";
  };

  sparqlPlugin = fetchurl {
    url = "https://repo1.maven.org/maven2/edu/stanford/protege/sparql-query-plugin/3.0.0/sparql-query-plugin-3.0.0.jar";
    hash = "sha256-McDZAOjkXVxNvt5tAzwhhoFJFliTzsge4/jCXE+Sp00=";
  };

  codeGenPlugin = fetchurl {
    url = "https://repo1.maven.org/maven2/edu/stanford/protege/code-generation/2.0.0/code-generation-2.0.0.jar";
    hash = "sha256-FlMEKeRc+4w0MaCsJD+wMeF/TN61UaL9TyAsqp47H8s=";
  };

  explanationPlugin = fetchurl {
    url = "https://repo1.maven.org/maven2/edu/stanford/protege/explanation-workbench/3.0.1/explanation-workbench-3.0.1.jar";
    hash = "sha256-PAwDuggy122hT00jWbN+0u+BQ1JTXlplI3xIqR9r+aw=";
  };

  ontografPlugin = fetchurl {
    url = "https://repo1.maven.org/maven2/edu/stanford/protege/ontograf/2.0.3/ontograf-2.0.3.jar";
    hash = "sha256-XRJMlKNT3Ei7aNGRr1qTjXiBAxZzZOPm+0+R/FEpCiE=";
  };

  existentialPlugin = fetchurl {
    url = "https://repo1.maven.org/maven2/edu/stanford/protege/existentialquery/2.0.0/existentialquery-2.0.0.jar";
    hash = "sha256-hxgv5Ub8zHbhXgmQD2zHENeTpkPZ27rZU3lHcK7YgCw=";
  };

  owlDocPlugin = fetchurl {
    url = "https://repo1.maven.org/maven2/edu/stanford/protege/owldoc/3.0.3/owldoc-3.0.3.jar";
    hash = "sha256-pgz9fOUSdVaumMnQ31CJ+rIffqLYuxi4xSRHg3q39Jo=";
  };

  cellfiePlugin = fetchurl {
    url = "https://repo1.maven.org/maven2/edu/stanford/protege/cellfie/2.1.0/cellfie-2.1.0.jar";
    hash = "sha256-kVlGd7jP7BPHgnt3o7Md/uDzvIm2NtDq9/qIbBs77zk=";
  };

  swrlTabPlugin = fetchurl {
    url = "https://repo1.maven.org/maven2/edu/stanford/swrl/swrltab-plugin/2.0.10/swrltab-plugin-2.0.10.jar";
    hash = "sha256-zhTTYMxQw/pG/uv+zxxS17QT8gPQj0pWURBBxz0zioU=";
  };

  elkPlugin = fetchurl {
    url = "https://repo1.maven.org/maven2/io/github/liveontologies/elk-protege/0.6.0/elk-protege-0.6.0.jar";
    hash = "sha256-aP37eXF+Q11u83g3fnY4Qtt52K8g4kY20QPOJt9kP0w=";
  };
in
maven.buildMavenPackage rec {
  pname = "protege-distribution";
  version = "5.6.8";

  src = fetchFromGitHub {
    owner = "protegeproject";
    repo = "protege";
    rev = version;
    hash = "sha256-GplMEVEBYSTTzrGzbHlbQTXqJYka6r0QfBZFVCS7wCs=";
  };

  mvnJdk = jdk11;
  mvnHash = "sha256-xC/zLPPLbQ8tZIkCZHOfY6FEaWXFF5ZC1LX4ovaSSqg=";

  patches = [
    ./enforce-plugin-versions.patch
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

    # Move the built application to the output directory
    mv protege-desktop/target/protege-${version}-platform-independent/Protege-${version} $out/Protege


    mkdir -p $out/Protege/plugins

    cp ${hermitPlugin} $out/Protege/plugins/org.semanticweb.hermit.jar
    cp ${dlQueryPlugin} $out/Protege/plugins/org.coode.dlquery.jar
    cp ${owlVizPlugin} $out/Protege/plugins/owlviz.jar
    cp ${rdfLibraryPlugin} $out/Protege/plugins/rdf-library.jar
    cp ${sparqlPlugin} $out/Protege/plugins/sparql-query-plugin.jar
    cp ${codeGenPlugin} $out/Protege/plugins/code-generation.jar
    cp ${explanationPlugin} $out/Protege/plugins/explanation-workbench.jar
    cp ${ontografPlugin} $out/Protege/plugins/ontograf.jar
    cp ${existentialPlugin} $out/Protege/plugins/existentialquery.jar
    cp ${owlDocPlugin} $out/Protege/plugins/owldoc.jar
    cp ${cellfiePlugin} $out/Protege/plugins/cellfie.jar
    cp ${swrlTabPlugin} $out/Protege/plugins/swrltab-plugin.jar
    cp ${elkPlugin} $out/Protege/plugins/elk-protege.jar


    # Place a wrapper for the launcher script
    makeWrapper $out/Protege/run.sh $out/bin/protege \
      --set JAVA_HOME ${jdk11.home}

    # Link all jars from within the standard /share/protege directory
    ln -s -t $out/share/protege $out/Protege/bundles/*

    # Generate icons
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
    maintainers = with lib.maintainers; [
      nessdoor
      Oxy8
    ];
    license = with lib.licenses; [ bsd2 ];
    platforms = lib.platforms.unix;
    mainProgram = "protege";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
}
