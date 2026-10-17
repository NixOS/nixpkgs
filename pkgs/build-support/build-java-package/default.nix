{
  lib,
  stdenvNoCC,
  buildPackages,
  jdk ? buildPackages.jdk,
  stripJavaArchivesHook ? buildPackages.stripJavaArchivesHook,
}:

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  excludeDrvArgNames = [
    "classpath"
    "propagatedClasspath"
    "extraClasspath"
    "javaRelease"
    "encoding"
    "javaSourceDir"
    "excludeSourcePatterns"
    "resourcesDir"
    "javacFlags"
    "jarName"
    "jdk"
  ];

  extendDrvArgs =
    finalAttrs:
    args@{
      pname,
      version,
      src,

      # List of Java dependencies whose `share/java/*.jar` files are added to the compilation classpath and `buildInputs`
      classpath ? [ ],

      # Propagated using `propagatedBuildInputs`
      propagatedClasspath ? [ ],
      extraClasspath ? "",

      # Java release version passed to `javac --release` (default `8` for most compatibility).
      # Set to `null` to omit `--release` and use custom `-source`/`-target` via `javacFlags`.
      javaRelease ? 8,
      encoding ? "UTF-8",
      javaSourceDir ? "src/main/java",
      excludeSourcePatterns ? [ ],
      resourcesDir ? "src/main/resources",
      javacFlags ? [ ],
      jarName ? finalAttrs.pname,

      # Compiler derivation to use in `nativeBuildInputs`
      jdk' ? (args.jdk or jdk),

      meta ? { },
      passthru ? { },
      ...
    }:
    let
      releaseArg = lib.optionalString (javaRelease != null) "--release ${toString javaRelease}";
      allClasspath = classpath ++ propagatedClasspath;
      copyResources = lib.optionalString (resourcesDir != null) ''
        if [ -d "${resourcesDir}" ]; then
          cp -r ${resourcesDir}/. build/classes/ 2>/dev/null || true
        fi
      '';
    in
    {
      __structuredAttrs = args.__structuredAttrs or true;
      strictDeps = args.strictDeps or true;

      nativeBuildInputs = [
        jdk'
        stripJavaArchivesHook
      ]
      ++ (args.nativeBuildInputs or [ ]);

      buildInputs = allClasspath ++ (args.buildInputs or [ ]);
      propagatedBuildInputs = propagatedClasspath ++ (args.propagatedBuildInputs or [ ]);

      buildPhase =
        args.buildPhase or ''
          runHook preBuild

          mkdir -p build/classes

          find ${javaSourceDir} -name "*.java" \
            ! -path "./META-INF/*" \
            ${lib.concatMapStrings (pat: "! -path '${pat}' ") excludeSourcePatterns} \
            > sources.txt

          build_cp=""
          ${lib.concatMapStringsSep "\n" (dep: ''
            if [ -d "${dep}/share/java" ]; then
              for j in "${dep}/share/java"/*.jar; do
                [ -e "$j" ] || continue
                if [ -L "$j" ] && [ -e "$(readlink -f "$j")" ]; then
                  continue
                fi
                build_cp="''${build_cp:+$build_cp:}$j"
              done
            fi
          '') allClasspath}
          if [ -n "${extraClasspath}" ]; then
            build_cp="''${build_cp:+$build_cp:}${extraClasspath}"
          fi

          cp_arg=""
          if [ -n "$build_cp" ]; then
            cp_arg="-classpath $build_cp"
          fi

          javac \
            ${releaseArg} \
            -encoding ${encoding} \
            $cp_arg \
            ${lib.escapeShellArgs javacFlags} \
            -d build/classes \
            @sources.txt

          ${copyResources}

          jar cf ${jarName}-${finalAttrs.version}.jar -C build/classes .

          runHook postBuild
        '';

      installPhase =
        args.installPhase or ''
          runHook preInstall

          install -Dm644 ${jarName}-${finalAttrs.version}.jar \
            $out/share/java/${jarName}-${finalAttrs.version}.jar
          ln -s ${jarName}-${finalAttrs.version}.jar \
            $out/share/java/${jarName}.jar

          runHook postInstall
        '';

      passthru = {
        inherit classpath propagatedClasspath;
      }
      // passthru;

      meta = {
        platforms = lib.platforms.all;
        sourceProvenance = with lib.sourceTypes; [ fromSource ];
      }
      // meta;
    };
}
