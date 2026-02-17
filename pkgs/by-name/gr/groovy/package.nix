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

stdenv.mkDerivation (finalAttrs: {
  pname = "groovy";
  version = "5.0.2";

  src = fetchurl {
    url = "mirror://apache/groovy/${finalAttrs.version}/distribution/apache-groovy-binary-${finalAttrs.version}.zip";
    sha256 = "sha256-cPgvEbG3ZOIH3PVWiILHjcdyk/MHgWJCOUo/enTyDoE=";
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
      comment = finalAttrs.meta.description;
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
})
