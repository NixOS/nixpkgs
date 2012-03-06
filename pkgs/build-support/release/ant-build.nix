{ src
, pkgs
, stdenv ? pkgs.stdenv
, name
, antTargets ? []
, jars ? []
, jarWrappers ? []
, antProperties ? []
, antBuildInputs ? []
, buildfile ? "build.xml"
, ant ? pkgs.ant
, jre ? pkgs.jre
, hydraAntLogger ? pkgs.hydraAntLogger
, ... } @ args:

let
  antFlags = "-f ${buildfile} " + stdenv.lib.concatMapStrings ({name, value}: "-D${name}=${value} " ) antProperties ;
  lib = stdenv.lib;
in
stdenv.mkDerivation (

  {
    inherit jre ant;
    showBuildStats = true;

    postPhases =
      ["generateWrappersPhase" "finalPhase"];

    prePhases = 
      ["antSetupPhase"];

    antSetupPhase = with stdenv.lib; ''
      if test "$hydraAntLogger" != "" ; then
        export ANT_ARGS="-logger org.hydra.ant.HydraLogger -lib `ls $hydraAntLogger/lib/java/*.jar | head -1`"
      fi
      for abi in ${concatStringsSep " " (map (f: "`find ${f} -name '*.jar'`") antBuildInputs)}; do
        export ANT_ARGS="$ANT_ARGS -lib $abi"
      done
    '';

    installPhase = ''
      mkdir -p $out/lib/java
      ${ if jars == [] then '' 
           find . -name "*.jar" | xargs -I{} cp -v {} $out/lib/java
         '' else stdenv.lib.concatMapStrings (j: ''
           cp -v ${j} $out/lib/java
         '') jars }
      for j in $out/lib/java/*.jar ; do
        echo file jar $j >> $out/nix-support/hydra-build-products
      done
    '';

    generateWrappersPhase = 
      let 
        cp = w: "-cp '${lib.optionalString (w ? classPath) w.classPath}${lib.optionalString (w ? mainClass) ":$out/lib/java/*"}'";
      in
      '' 
      header "Generating jar wrappers"
    '' + (stdenv.lib.concatMapStrings (w: ''

      mkdir -p $out/bin
      cat >> $out/bin/${w.name} <<EOF
      #! /bin/sh
      export JAVA_HOME=$jre
      $jre/bin/java ${cp w} ${if w ? mainClass then w.mainClass else "-jar ${w.jar}"} \$@
      EOF

      chmod a+x $out/bin/${w.name} || exit 1
    '') jarWrappers) + ''
      closeNest
    '';

    buildPhase = if antTargets == [] then ''
      header "Building default ant target"
      ant ${antFlags}
      closeNest
    '' else stdenv.lib.concatMapStrings (t: ''
      header "Building '${t}' target"
      ant ${antFlags} ${t} 
      closeNest
    '') antTargets;

    finalPhase =
      ''
        # Propagate the release name of the source tarball.  This is
        # to get nice package names in channels.
        if test -e $origSrc/nix-support/hydra-release-name; then
          cp $origSrc/nix-support/hydra-release-name $out/nix-support/hydra-release-name
        fi
      '';
  }

  // removeAttrs args ["antProperties" "buildInputs" "pkgs" "jarWrappers"] // 

  {
    name = name + (if src ? version then "-" + src.version else "");
  
    buildInputs = [ant jre] ++ stdenv.lib.optional (args ? buildInputs) args.buildInputs ;

    postHook = ''
      mkdir -p $out/nix-support
      echo "$system" > $out/nix-support/system

      # If `src' is the result of a call to `makeSourceTarball', then it
      # has a subdirectory containing the actual tarball(s).  If there are
      # multiple tarballs, just pick the first one.
      origSrc=$src
      if test -d $src/tarballs; then
          src=$(ls $src/tarballs/*.tar.bz2 $src/tarballs/*.tar.gz | sort | head -1)
      fi

    ''; 
  }
)
