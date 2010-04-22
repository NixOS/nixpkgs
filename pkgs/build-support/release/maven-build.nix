{ stdenv
, name
, src
, doTest ? true
, doTestCompile ? true
, doJavadoc ? false
, doCheckstyle ? false
, doRelease ? false
, includeTestClasses ? true
, extraMvnFlags ? ""
, ...
} @ args :

let 
  mvnFlags = "-Dmaven.repo.local=$M2_REPO ${if doTest then "" else "-Dmaven.test.skip.exec=true"} ${extraMvnFlags}";
in

stdenv.mkDerivation ( rec {
  inherit name src; 
  phases = "setupPhase unpackPhase patchPhase mvnCompile ${if doTestCompile then "mvnTestCompile mvnTestJar" else ""} ${if doTest then "mvnTest mvnCobertura" else ""} ${if doJavadoc then "mvnJavadoc" else ""} ${if doCheckstyle then "mvnCheckstyle" else ""} mvnJar mvnAssembly mvnRelease finalPhase";

  setupPhase = ''
    runHook preSetupPhase

    ensureDir $out/nix-support
    export LANG="en_US.UTF-8"
    export LOCALE_ARCHIVE=$glibcLocales/lib/locale/locale-archive
    export M2_REPO=$TMPDIR/repository

    runHook postSetupPhase
  '';

  mvnCompile = ''
    mvn compile ${mvnFlags}
  '';  

  mvnTestCompile = ''
    mvn test-compile ${mvnFlags}
  '';  

  mvnTestJar = ''
    mvn jar:test-jar ${mvnFlags}
  '';  

  mvnTest = ''
    mvn test ${mvnFlags}
  '';  

  mvnJavadoc = ''
    mvn javadoc:javadoc ${mvnFlags}
    cp -R target/site/apidocs $out/apidocs
    echo "report javadoc $out/apidocs" >> $out/nix-support/hydra-build-products
  '';  

  mvnCobertura = ''
    mvn cobertura:cobertura ${mvnFlags}
    cp -R target/site/cobertura $out/cobertura
    echo "report cobertura $out/cobertura" >> $out/nix-support/hydra-build-products
  '';  

  mvnCheckstyle = ''
    mvn checkstyle:checkstyle ${mvnFlags}
    ensureDir $out/checkstyle
    cp -R target/site/checkstyle.* $out/checkstyle/
    cp -R target/site/images $out/checkstyle/images
    echo "report checkstyle $out/checkstyle/checkstyle.html" >> $out/nix-support/hydra-build-products
  '';  

  mvnJar = ''
    mvn jar:jar ${mvnFlags}
  '';  

  mvnAssembly = ''
    mvn assembly:assembly ${mvnFlags}
  '';

  mvnRelease = ''
    ensureDir $out/release
ls -l target/
    zip=$(ls target/*.zip| head -1)
    releaseName=$(basename $zip .zip)
    releaseName="$releaseName-r${toString src.rev}"
    cp $zip $out/release/$releaseName.zip
    
    echo "$releaseName" > $out/nix-support/hydra-release-name

    ${if doRelease then  ''
    echo "file zip $out/release/$releaseName.zip" >> $out/nix-support/hydra-build-products
    '' else ""}
  '';  

  finalPhase = ''
    ensureDir $out/site
    cp -R src/test/site/* $out/site
  '';
} // args 
)
