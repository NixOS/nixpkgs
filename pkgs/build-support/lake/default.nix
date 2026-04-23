# buildLakePackage: build Lean 4 projects that use the Lake build system.
#
# Dependencies can be provided in two ways:
#   - `leanDeps`: nix-packaged Lean libraries, injected via
#     `lake --packages` and propagated transitively via LEAN_PATH.
#   - `lakeHash`: SRI hash for a fetchLakeDeps FOD that clones git
#     dependencies listed in lake-manifest.json (like buildGoModule's
#     vendorHash).  Not needed when all deps are in `leanDeps`.
{
  lib,
  stdenv,
  lean4,
  gitMinimal,
  cacert,
  jq,
  writeText,
  stdenvNoCC,
}:

let
  fetchLakeDeps = import ./fetch-lake-deps.nix {
    inherit
      lib
      stdenvNoCC
      gitMinimal
      cacert
      jq
      ;
  };
in

lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;
  excludeDrvArgNames = [
    "lakeHash"
    "lakeDeps"
    "leanDeps"
    "buildTargets"
    "isLibrary"
    "leanPackageName"
    "overrideLakeDepsAttrs"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      nativeBuildInputs ? [ ],
      passthru ? { },

      # SRI hash for the Lake dependencies FOD (null = all deps nix-managed).
      lakeHash ? null,
      # Pre-built Lake dependencies derivation (overrides lakeHash).
      lakeDeps ? null,
      # Nix-packaged Lean libraries, injected via lake --packages.
      leanDeps ? [ ],
      # Lake package name as declared in lakefile (defaults to pname).
      leanPackageName ? finalAttrs.pname,
      # Lake build targets (empty = default targets).
      buildTargets ? [ ],
      # Library (install .olean tree) or executable (install binaries only).
      isLibrary ? true,
      # Override the FOD derivation attrs.
      overrideLakeDepsAttrs ? (finalAttrs: previousAttrs: { }),

      meta ? { },

      ...
    }@args:
    let
      lakeDeps' = args.lakeDeps or null;
      lakeHash = args.lakeHash or null;
      leanDeps = args.leanDeps or [ ];
      overrideLakeDepsAttrs = args.overrideLakeDepsAttrs or (_: _: { });
      buildTargets = args.buildTargets or [ ];
      isLibrary = args.isLibrary or true;
      leanPackageName = args.leanPackageName or finalAttrs.pname;

      allLeanDeps = lib.unique (
        builtins.concatMap (dep: [ dep ] ++ (dep.passthru.allLeanDeps or [ ])) leanDeps
      );

      computedLakeDeps =
        if lakeDeps' != null then
          lakeDeps'
        else if lakeHash == null then
          null
        else
          (fetchLakeDeps {
            name = finalAttrs.name or "${finalAttrs.pname}-${finalAttrs.version}";
            inherit (finalAttrs) src;
            hash = lakeHash;
            sourceRoot = finalAttrs.sourceRoot or "";
            patches = finalAttrs.patches or [ ];
            prePatch = finalAttrs.prePatch or "";
            postPatch = finalAttrs.postPatch or "";
            excludePackages = map (dep: dep.passthru.lakePackageName or dep.pname) allLeanDeps;
          }).overrideAttrs
            (lib.toExtension overrideLakeDepsAttrs);

      # Nix-managed dep overrides, generated at eval time.
      # --packages takes precedence over .lake/package-overrides.json.
      overridesFile = writeText "lake-overrides.json" (
        builtins.toJSON {
          schemaVersion = "1.2.0";
          packages = map (dep: {
            type = "path";
            name = dep.passthru.lakePackageName or dep.pname;
            inherited = false;
            dir = "${dep}";
          }) allLeanDeps;
        }
      );
    in
    {
      strictDeps = true;

      nativeBuildInputs = nativeBuildInputs ++ [
        lean4
        gitMinimal
        jq
      ];

      propagatedBuildInputs = lib.optionals isLibrary leanDeps;
      buildInputs = lib.optionals (!isLibrary) leanDeps;

      configurePhase =
        args.configurePhase or ''
          runHook preConfigure

          export HOME="$TMPDIR"

          # Disable cloud caching and Reservoir lookups.
          export LAKE_NO_CACHE=1
          export RESERVOIR_API_URL=""
          export LEAN_CC="${stdenv.cc}/bin/cc"

          if [ -n "''${LEAN_PATH:-}" ]; then
            echo "buildLakePackage: LEAN_PATH=$LEAN_PATH"
          fi

          ${lib.optionalString (computedLakeDeps != null) ''
            mkdir -p .lake/packages
            for dep in ${computedLakeDeps}/*; do
              depName="$(basename "$dep")"
              cp -r "$dep" ".lake/packages/$depName"
              chmod -R u+w ".lake/packages/$depName"
            done

            # FOD deps use package-overrides.json (the on-disk mechanism).
            # Nix-managed deps use --packages (the CLI mechanism, takes precedence).
            jq -n --argjson pkgs "$(
              for dep in .lake/packages/*/; do
                [ -d "$dep" ] || continue
                depName="$(basename "$dep")"
                jq -n --arg name "$depName" --arg dir ".lake/packages/$depName" \
                  '{type: "path", name: $name, inherited: false, dir: $dir}'
              done | jq -s '.'
            )" '{schemaVersion: "1.2.0", packages: $pkgs}' > .lake/package-overrides.json
          ''}

          runHook postConfigure
        '';

      buildPhase =
        args.buildPhase or ''
          runHook preBuild

          local targets="${lib.concatStringsSep " " buildTargets}"
          echo "buildLakePackage: building ''${targets:-default targets}"

          lake build --no-ansi --packages=${overridesFile} $targets

          runHook postBuild
        '';

      installPhase =
        args.installPhase or (
          if isLibrary then
            ''
              runHook preInstall

              # Install the complete Lake package tree.
              cp -rT . "$out"

              # Remove build-time artifacts.
              rm -rf "$out/.lake/packages"
              rm -f "$out/.lake/package-overrides.json"

              # Reconcile config trace directory naming.
              if [ -d "$out/.lake/config/[anonymous]" ]; then
                mv "$out/.lake/config/[anonymous]" "$out/.lake/config/${leanPackageName}"
              fi

              # Setup hook propagates LEAN_PATH to downstream packages.
              mkdir -p "$out/nix-support"
              cp ${./setup-hook.sh} "$out/nix-support/setup-hook"

              if [ -d "$out/.lake/build/bin" ]; then
                mkdir -p "$out/bin"
                for exe in "$out/.lake/build/bin"/*; do
                  if [ -f "$exe" ] && [ -x "$exe" ]; then
                    ln -s "../.lake/build/bin/$(basename "$exe")" "$out/bin/$(basename "$exe")"
                  fi
                done
              fi

              runHook postInstall
            ''
          else
            ''
              runHook preInstall

              if [ -d .lake/build/bin ]; then
                mkdir -p "$out/bin"
                find .lake/build/bin -type f -executable \
                  -exec install -Dm755 {} "$out/bin/" \;
              fi

              runHook postInstall
            ''
        );

      passthru = passthru // {
        inherit computedLakeDeps lean4 allLeanDeps;
        lakePackageName = leanPackageName;
        overrideLakeDepsAttrs = lib.toExtension overrideLakeDepsAttrs;
      };

      meta = meta // {
        platforms = meta.platforms or lean4.meta.platforms;
      };
    };
}
