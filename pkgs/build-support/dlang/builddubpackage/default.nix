{
  lib,
  stdenv,
  makeDubDep,
  linkFarm,
  dub,
  ldc,
  removeReferencesTo,
}:

# TODO: create proper documentation
# until then you can ping @TomaSajt if you have any questions

{
  dubDeps,
  extraDubDeps ? [ ],
  dubBuildType ? "release",
  dubFlags ? [ ],
  compiler ? ldc,
  ...
}@args:

let
  # this currently only supports .zip files
  combinedDeps = (import dubDeps { inherit makeDubDep; }) ++ extraDubDeps;

  # a directory with multiple single element registries
  dubRegistryBase = linkFarm "dub-registry-base" (
    map (dep: {
      name = "${dep.pname}/${dep.pname}-${dep.version}.zip";
      path = dep.src;
    }) combinedDeps
  );
in
stdenv.mkDerivation (
  builtins.removeAttrs args [
    "dubDeps"
    "extraDubDeps"
  ]
  // {
    nativeBuildInputs = args.nativeBuildInputs or [ ] ++ [
      dub
      compiler
      removeReferencesTo
    ];

    configurePhase =
      args.configurePhase or ''
        runHook preConfigure

        export DUB_HOME="$NIX_BUILD_TOP/.dub"
        mkdir -p $DUB_HOME

        # register dependencies
        ${lib.concatMapStringsSep "\n" (dep: ''
          dub fetch ${dep.pname}@${dep.version} --cache=user --skip-registry=standard --registry=file://${dubRegistryBase}/${dep.pname}
        '') combinedDeps}

        runHook postConfigure
      '';

    buildPhase =
      args.buildPhase or ''
        runHook preBuild

        dub build --skip-registry=all --compiler=${lib.getExe compiler} --build=${dubBuildType} ${toString dubFlags}

        runHook postBuild
      '';

    preFixup = ''
      ${args.preFixup or ""}

      find "$out" -type f -exec remove-references-to -t ${compiler} '{}' +
    '';

    disallowedReferences = [ compiler ];

    meta = {
      platforms = dub.meta.platforms;
    } // args.meta or { };
  }
)
