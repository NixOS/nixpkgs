{ src
, stdenv
, name
, antTargets ? []
, jars ? []
, jarWrappers ? []
, antProperties ? []
, ... } @ args:

let
  antFlags = stdenv.lib.concatMapStrings ({name, value}: "-D${name}=${value}" ) antProperties ;
in
stdenv.mkDerivation (

  {
    showBuildStats = true;

    postPhases =
      ["generateWrappersPhase" "finalPhase"];

    installPhase = ''
      ensureDir $out/lib/java
      ${ if jars == [] then '' 
           find . -name "*.jar" | xargs -I{} cp -v {} $out/lib/java
         '' else stdenv.lib.concatMapStrings (j: ''
           cp -v ${j} $out/lib/java
           echo file jar $out/lib/java/${j} >> $out/nix-support/hydra-build-products
         '') jars }
    '';

    generateWrappersPhase = '' 
      header "Generating jar wrappers"
    '' + (stdenv.lib.concatMapStrings (w: ''

      cat >> $out/bin/jclasslib <<EOF
      #! /bin/sh
      export JAVA_HOME=$jre
      $jre/bin/java ${if w ? mainClass then "-cp $out/lib/java/${w.jar} ${w.mainClass}" else "-jar $out/lib/java/${w.jar}"} \$@
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

  // removeAttrs args ["antProperties"] // 

  {
    name = name + (if src ? version then "-" + src.version else "");
  
    postHook = ''
      ensureDir $out/nix-support
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
