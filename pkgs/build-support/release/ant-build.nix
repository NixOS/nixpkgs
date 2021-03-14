{ src
, pkgs
, lib
, stdenv ? pkgs.stdenv
, name
, antTargets ? []
, jars ? []
, jarWrappers ? []
, antProperties ? []
, antBuildInputs ? []
, buildfile ? "build.xml"
, ant ? pkgs.ant
, jre ? pkgs.jdk
, hydraAntLogger ? pkgs.hydraAntLogger
, zip ? pkgs.zip
, unzip ? pkgs.unzip
, ... } @ args:

let
  antFlags = "-f ${buildfile} " + lib.concatMapStrings ({name, value}: "-D${name}=${value} " ) antProperties ;
in
stdenv.mkDerivation (

  {
    inherit jre ant;
    showBuildStats = true;

    postPhases =
      ["generateWrappersPhase" "finalPhase"];

    prePhases =
      ["antSetupPhase"];

    antSetupPhase = with lib; ''
      if test "$hydraAntLogger" != "" ; then
        export ANT_ARGS="-logger org.hydra.ant.HydraLogger -lib `ls $hydraAntLogger/share/java/*.jar | head -1`"
      fi
      for abi in ${concatStringsSep " " (map (f: "`find ${f} -name '*.jar'`") antBuildInputs)}; do
        export ANT_ARGS="$ANT_ARGS -lib $abi"
      done
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/java
      ${ if jars == [] then ''
           find . -name "*.jar" | xargs -I{} cp -v {} $out/share/java
         '' else lib.concatMapStrings (j: ''
           cp -v ${j} $out/share/java
         '') jars }

      . ${./functions.sh}
      for j in $out/share/java/*.jar ; do
        canonicalizeJar $j
        echo file jar $j >> $out/nix-support/hydra-build-products
      done

      runHook postInstall
    '';

    generateWrappersPhase =
      let
        cp = w: "-cp '${lib.optionalString (w ? classPath) w.classPath}${lib.optionalString (w ? mainClass) ":$out/share/java/*"}'";
      in
      ''
      header "Generating jar wrappers"
    '' + (lib.concatMapStrings (w: ''

      mkdir -p $out/bin
      cat >> $out/bin/${w.name} <<EOF
      #!${pkgs.runtimeShell}
      export JAVA_HOME=$jre
      $jre/bin/java ${cp w} ${if w ? mainClass then w.mainClass else "-jar ${w.jar}"} \$@
      EOF

      chmod a+x $out/bin/${w.name} || exit 1
    '') jarWrappers) + ''
      closeNest
    '';

    buildPhase = ''
      runHook preBuild
    '' + (if antTargets == [] then ''
      header "Building default ant target"
      ant ${antFlags}
      closeNest
    '' else lib.concatMapStrings (t: ''
      header "Building '${t}' target"
      ant ${antFlags} ${t}
      closeNest
    '') antTargets) + ''
      runHook postBuild
    '';

    finalPhase =
      ''
        # Propagate the release name of the source tarball.  This is
        # to get nice package names in channels.
        if test -e $origSrc/nix-support/hydra-release-name; then
          cp $origSrc/nix-support/hydra-release-name $out/nix-support/hydra-release-name
        fi
      '';
  }

  // removeAttrs args ["antProperties" "buildInputs" "pkgs" "lib" "jarWrappers"] //

  {
    name = name + (if src ? version then "-" + src.version else "");

    buildInputs = [ant jre zip unzip] ++ lib.optional (args ? buildInputs) args.buildInputs ;

    postHook = ''
      mkdir -p $out/nix-support
      echo "$system" > $out/nix-support/system
      . ${./functions.sh}

      origSrc=$src
      src=$(findTarball $src)
    '';
  }
)
