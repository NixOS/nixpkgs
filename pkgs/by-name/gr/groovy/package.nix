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
  version = "5.0.4";

  src = fetchurl {
    url = "mirror://apache/groovy/${version}/distribution/apache-groovy-binary-${version}.zip";
    sha256 = "sha256-Xl6aRo1DRODI7gzWjGJ1HM9OX4+E162birxqAQFLn3k=";
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

  meta = {
    description = "Agile dynamic language for the Java Platform";
    homepage = "http://groovy-lang.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = with lib.platforms; unix;
  };
}
