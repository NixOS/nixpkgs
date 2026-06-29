{
  stdenv,
  lib,
  name,
  src,
  doTest ? true,
  doTestCompile ? true,
  doJavadoc ? false,
  doCheckstyle ? false,
  doRelease ? false,
  includeTestClasses ? true,
  extraMvnFlags ? "",
  ...
}@args:

let
  mvnFlags = lib.escapeShellArgs [
    "-Dmaven.repo.local=$M2_REPO"
    (lib.optionalString (!doTest) "-Dmaven.test.skip.exec=true")
    "${extraMvnFlags}"
  ];
in

stdenv.mkDerivation (
  {
    inherit name src;

    preUnpack = ''
      runHook preSetupPhase

      mkdir -p $out/nix-support
      export LANG="en_US.UTF-8"
      export LOCALE_ARCHIVE=$glibcLocales/lib/locale/locale-archive
      export M2_REPO=$TMPDIR/repository

      runHook postSetupPhase
    '';

    buildPhase = ''
      mvn compile ${mvnFlags}
    '';

    checkPhase =
      lib.optionalString doTestCompile ''
        mvn test-compile ${mvnFlags}
        mvn jar:test-jar ${mvnFlags}
      ''
      + lib.optionalString doTest ''
        mvn test ${mvnFlags}

        if [ -d target/site/cobertura ] ; then
          echo "report coverage $out/site/cobertura" >> $out/nix-support/hydra-build-products
        fi

        if [ -d target/surefire-reports ] ; then
          mvn surefire-report:report-only
          echo "report coverage $out/site/surefire-report.html" >> $out/nix-support/hydra-build-products
        fi
      '';

    installPhase =
      lib.optionalString doJavadoc ''
        mvn javadoc:javadoc ${mvnFlags}
        echo "report javadoc $out/site/apidocs" >> $out/nix-support/hydra-build-products
      ''
      + lib.optionalString doCheckstyle ''
        mvn checkstyle:checkstyle ${mvnFlags}
        echo "report checkstyle $out/site/checkstyle.html" >> $out/nix-support/hydra-build-products
      ''
      + ''
        mvn jar:jar ${mvnFlags}
        mvn assembly:assembly -Dmaven.test.skip=true ${mvnFlags}

        mkdir -p $out/release
        zip=$(ls target/*.zip | head -1)
        releaseName=$(basename $zip .zip)
        releaseName="$releaseName-r${toString src.rev or "0"}"
        cp $zip $out/release/$releaseName.zip

        echo "$releaseName" > $out/nix-support/hydra-release-name

        ${lib.optionalString doRelease ''
          echo "file zip $out/release/$releaseName.zip" >> $out/nix-support/hydra-build-products
        ''}

        if [ -d target/site ] ; then
          cp -R target/site $out/
          echo "report site $out/site" >> $out/nix-support/hydra-build-products
        fi
      '';
  }
  // args
)
