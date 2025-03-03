{
  lib,
  stdenv,
  fetchurl,
  unzip,
  which,
  makeWrapper,
  installShellFiles,
  jdk,
  copyDesktopItems,
  makeDesktopItem,
}:

# at runtime, need jdk

stdenv.mkDerivation rec {
  pname = "groovy";
  version = "4.0.24";

  src = fetchurl {
    url = "mirror://apache/groovy/${version}/distribution/apache-groovy-binary-${version}.zip";
    sha256 = "sha256-2/82g1VovsInGHb3C/zKbeuA4bF5RTzKk0pQLqMBu4A=";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
    installShellFiles
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "groovy";
      desktopName = "Groovy Console";
      exec = "groovyConsole";
      icon = "groovy";
      comment = meta.description;
      terminal = false;
      startupNotify = false;
      categories = [ "Development" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    rm bin/*.bat

    mkdir -p $out
    mkdir -p $out/share/doc/groovy

    #Install icons
    mkdir -p $out/share/icons
    mv bin/groovy.ico $out/share/icons/

    #Install Completion
    for p in grape groovy{,doc,c,sh,Console}; do
      installShellCompletion --cmd $p --bash bin/''${p}_completion
    done
    rm bin/*_completion

    mv {bin,conf,grooid,lib} $out
    mv {licenses,LICENSE,NOTICE} $out/share/doc/groovy

    sed -i 's#which#${which}/bin/which#g' $out/bin/startGroovy

    for p in grape java2groovy groovy{,doc,c,sh,Console}; do
      wrapProgram $out/bin/$p \
        --set JAVA_HOME "${jdk}" \
        --prefix PATH ":" "${jdk}/bin"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Agile dynamic language for the Java Platform";
    homepage = "http://groovy-lang.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
  };
}
