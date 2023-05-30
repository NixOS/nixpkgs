{ lib
, stdenv

, gradle
, perl

, gradleFlags
, gradleLockfile
, buildscriptGradleLockfile
, lockfileTree
, projectSubdir
, gradleDepsHash
, attrs
, generateMissingLockfiles }:

let
  self = stdenv.mkDerivation (attrs // {
    name = "${attrs.name or "${attrs.pname}-${attrs.version}"}-deps";
    inherit gradleLockfile buildscriptGradleLockfile lockfileTree;
    postPatch = (if attrs?postPatch then attrs.postPatch + "\n" else "") + ''
      cd ${projectSubdir}
      ${lib.optionalString generateMissingLockfiles ''
        if [ -n "$gradleLockfile" ]; then
          cp $gradleLockfile gradle.lockfile
        fi
        if [ -n "$buildscriptGradleLockfile" ]; then
          cp $buildscriptGradleLockfile buildscript-gradle.lockfile
        fi
        if [ -n "$lockfileTree" ]; then
          projectDir=$(pwd)
          pushd "$lockfileTree"
          for file in $(find . -type f -regex ".*\.lockfile"); do
            install -Dm755 "$file" "$projectDir/$file"
          done
          popd
        fi
      ''}
      export gradle=(gradle --no-daemon --init-script ${./init-deps.gradle} ${lib.escapeShellArgs gradleFlags})
    '';
    nativeBuildInputs = [gradle perl] ++ (attrs.nativeBuildInputs or []);
    # SNAPSHOT means always use latest build
    # latest.integration allows using version locks
    preBuild = ''
      if [ -z "$GRADLE_USER_HOME"]; then
        export GRADLE_USER_HOME=$(mktemp -d)
      fi
      export TERM=dumb
      sed -i '/dependencies/,/^}/s/:-SNAPSHOT"/latest.integration/g' *.gradle **/*.gradle
    '' + (if attrs?preBuild then attrs.preBuild + "\n" else "");
    buildPhase = attrs.buildPhase or ''
      runHook preBuild
      "''${gradle[@]}" nixSupport_downloadDeps
      runHook postBuild
    '';
    initialBuildPhase = attrs.initialBuildPhase or ''
      runHook preBuild
      "''${gradle[@]}" --write-locks nixSupport_downloadDeps
      rm -rf $GRADLE_USER_HOME
      export GRADLE_USER_HOME=$(mktemp -d)
      "''${gradle[@]}" nixSupport_downloadDeps
      runHook postBuild
    '';
    configurePhase = attrs.configurePhase or "true";
    # perl code mavenizes pathes (com.squareup.okio/okio/1.13.0/a9283170b7305c8d92d25aff02a6ab7e45d06cbe/okio-1.13.0.jar -> com/squareup/okio/okio/1.13.0/okio-1.13.0.jar)
    # there are many edge cases, so this is to be replaced with a more complex program
    installPhase = attrs.installPhase or ''
      runHook preInstall
      find $GRADLE_USER_HOME/caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
      ${lib.optionalString generateMissingLockfiles ''
        for file in $(find . -type f -regex '.*\.lockfile'); do
          install -Dm444 "$file" "$out/_nixLockfiles/$file"
        done
      ''}
      runHook postInstall
    '';
    fixupPhase = attrs.fixupPhase or "true";
    outputHashMode = "recursive";
    outputHash = gradleDepsHash;
    dontStrip = true;
    # info.picocli is the main culprit
    # (nix detects a folder named "info" not in $out/share and moves it, thank you very much...)
    forceShare = [ "dummy" ];

    outputs = [ "out" ];

    # this is a derivation with the purpose of updating the lock files
    # it isn't meant to be used by the end users, only by the maintainers
    # it's impure and you shouldn't expect it to always give the same hashes
    # the only purpose is getting the lockfiles to update the versions and
    # letting the maintainer copy it to the package
    passthru = lib.optionalAttrs generateMissingLockfiles {
      update = self.overrideAttrs (old: {
        name = old.name + "-temp";
        gradleLockfile = null;
        buildscriptGradleLockfile = null;
        postPatch = (if attrs?postPatch then attrs.postPatch + "\n" else "") + ''
          cd ${projectSubdir}
          export gradle=(gradle --no-daemon --init-script ${./init-deps.gradle} ${lib.escapeShellArgs gradleFlags})
        '';
        # yes, we need to do it twice...
        # the reason is some .pom files are downloaded just to check the metadata and generate the lockfiles
        # after we've generated it, they are considered unnecessary by gradle and won't be downloaded again
        # to keep the hashes the same in deps and deps.update, we simply redownload everything with the new lockfiles
        buildPhase = old.initialBuildPhase;
      });
    };
  });
in self

