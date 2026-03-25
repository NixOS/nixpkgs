# buildLakePackage: build Lean 4 projects that use the Lake build system.
#
# Dependencies can be provided in two ways:
#   - `leanDeps`: already-packaged Lean libraries from leanPackages.
#     These are injected into LEAN_PATH via setup hooks and propagated
#     transitively, similar to Haskell's libraryHaskellDepends.
#   - `lakeHash`: SRI hash for a fetchLakeDeps FOD that clones git
#     dependencies listed in lake-manifest.json (like buildGoModule's
#     vendorHash).  Not needed when all deps are in `leanDeps`.
#
# Library output layout:
#   $out/                         Package root (source + build artifacts)
#   $out/lakefile.{lean,toml}     Lake package configuration
#   $out/lean-toolchain           Lean version pin
#   $out/.lake/build/lib/lean/    Compiled .olean/.ilean files
#   $out/.lake/build/ir/          Compiled C/object files
#   $out/nix-support/setup-hook   LEAN_PATH propagation hook
{
  lib,
  stdenv,
  lean4,
  gitMinimal,
  cacert,
  jq,
  lndir,
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

      # SRI hash for the Lake dependencies FOD.
      # Set to null if the project has no external dependencies
      # (or all deps are provided via leanDeps).
      lakeHash ? null,

      # Pre-built Lake dependencies derivation (overrides lakeHash).
      lakeDeps ? null,

      # Already-packaged Lean libraries from nixpkgs.
      # These are added to LEAN_PATH (via setup hook) and propagated
      # transitively.  Each must be a buildLakePackage output with
      # .olean files under $out/.lake/build/lib/lean/.
      leanDeps ? [ ],

      # Lean package name as declared in lakefile.lean/toml.
      # Defaults to pname.
      leanPackageName ? finalAttrs.pname,

      # Lake build targets.  Empty list means the default target.
      buildTargets ? [ ],

      # Whether this is a library (install full package tree with
      # .olean/.ilean files) or an executable (install binaries only).
      isLibrary ? true,

      # Override attributes of the lakeDeps derivation.
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
            excludePackages = builtins.map (dep: dep.passthru.lakePackageName or dep.pname) allLeanDeps;
          }).overrideAttrs
            (lib.toExtension overrideLakeDepsAttrs);

      # Transitively collect all Lean dependencies.  Each buildLakePackage
      # library stores its own transitive closure in passthru.allLeanDeps,
      # so this flattens the entire dependency DAG.
      allLeanDeps = lib.unique (
        builtins.concatMap (dep: [ dep ] ++ (dep.passthru.allLeanDeps or [ ])) leanDeps
      );
    in
    {
      strictDeps = true;

      nativeBuildInputs = nativeBuildInputs ++ [
        lean4
        gitMinimal
        jq
        lndir
      ];

      # Propagate so downstream packages get transitive LEAN_PATH entries
      # via each dependency's nix-support/setup-hook.
      propagatedBuildInputs = lib.optionals isLibrary leanDeps;

      # Executables only need deps at build time.
      buildInputs = lib.optionals (!isLibrary) leanDeps;

      configurePhase =
        args.configurePhase or ''
          runHook preConfigure

          export HOME="$TMPDIR"

          # Disable Lake cloud caching and Reservoir lookups
          export LAKE_NO_CACHE=1
          export RESERVOIR_API_URL=""

          # Point leanc at the nix-provided C compiler
          export LEAN_CC="${stdenv.cc}/bin/cc"

          # Validate that the lean-toolchain file (if present) matches the
          # Lean toolchain we are building against.  Mismatches between the
          # toolchain version and the compiler produce confusing errors, so
          # fail early with a clear message.
          leanVersion="${lean4.version}"
          if [ -f lean-toolchain ]; then
            toolchainVersion=$(sed -n 's/^.*:v\([0-9][0-9.]*\).*/\1/p' lean-toolchain)
            if [ -n "$toolchainVersion" ] && [ "$toolchainVersion" != "$leanVersion" ]; then
              echo "buildLakePackage: lean-toolchain requests v$toolchainVersion but lean4 is v$leanVersion" >&2
              echo "buildLakePackage: update the package or use a matching lean4 version" >&2
              exit 1
            fi
          fi

          ${lib.concatStringsSep "\n" (
            builtins.map (
              dep:
              let
                name = dep.passthru.lakePackageName or dep.pname;
              in
              ''
                # Fail fast if nix-packaged dep "${name}" was built against a
                # different Lean version.  This avoids wasting build time when
                # the package set is mid-update (e.g. lean4 bumped but a dep
                # has not been updated yet).
                if [ -f "${dep}/lean-toolchain" ]; then
                  depToolchain=$(sed -n 's/^.*:v\([0-9][0-9.]*\).*/\1/p' "${dep}/lean-toolchain")
                  if [ -n "$depToolchain" ] && [ "$depToolchain" != "$leanVersion" ]; then
                    echo "buildLakePackage: dependency ${name} was built with Lean v$depToolchain but lean4 is v$leanVersion" >&2
                    echo "buildLakePackage: update ${name} first, or override lean4 in leanPackages" >&2
                    exit 1
                  fi
                fi
              ''
            ) allLeanDeps
          )}

          if [ -n "''${LEAN_PATH:-}" ]; then
            echo "buildLakePackage: LEAN_PATH=$LEAN_PATH"
          fi

          mkdir -p .lake/packages

          # Create a minimal empty manifest if none exists.  Lake requires
          # this file, but when all deps come from leanDeps (nix-managed),
          # the actual dependency entries come from package-overrides.json.
          if [ ! -f lake-manifest.json ]; then
            echo '{"version":"1.1.0","packagesDir":".lake/packages","packages":[]}' \
              > lake-manifest.json
          fi

          ${lib.optionalString (computedLakeDeps != null) ''
            # Copy fetched (not yet nix-packaged) deps into .lake/packages/
            for dep in ${computedLakeDeps}/*; do
              depName="$(basename "$dep")"
              cp -r "$dep" ".lake/packages/$depName"
              chmod -R u+w ".lake/packages/$depName"
            done
          ''}

          ${lib.concatStringsSep "\n" (
            builtins.map (
              dep:
              let
                name = dep.passthru.lakePackageName or dep.pname;
              in
              ''
                # Install nix-packaged dep "${name}" into .lake/packages/.
                # lndir creates a symlink tree so artifacts remain as
                # zero-copy references to the store; writable dirs let Lake
                # create metadata during workspace initialization.
                rm -rf ".lake/packages/${name}"
                mkdir -p ".lake/packages/${name}"
                lndir -silent "${dep}" ".lake/packages/${name}"
              ''
            ) allLeanDeps
          )}

          # Generate package-overrides.json redirecting deps to local
          # paths.  Scans .lake/packages/ so that nix-managed deps work
          # even without a lake-manifest.json (like Haskell's package DB
          # approach — nix is the sole dependency provider, Lake just
          # validates against lakefile.lean at build time).
          if [ -d .lake/packages ] && [ -n "$(ls -A .lake/packages/ 2>/dev/null)" ]; then
            jq -n --argjson pkgs "$(
              for dep in .lake/packages/*/; do
                [ -d "$dep" ] || continue
                depName="$(basename "$dep")"
                printf '{"type":"path","name":"%s","inherited":false,"configFile":"lakefile","dir":".lake/packages/%s"}\n' \
                  "$depName" "$depName"
              done | jq -s '.'
            )" '{schemaVersion: "1.1.0", packages: $pkgs}' > .lake/package-overrides.json
          fi

          runHook postConfigure
        '';

      buildPhase =
        args.buildPhase or ''
          runHook preBuild

          local targets="${lib.concatStringsSep " " buildTargets}"
          echo "buildLakePackage: building ''${targets:-default targets}"

          lake build --no-ansi $targets

          runHook postBuild
        '';

      installPhase =
        args.installPhase or (
          if isLibrary then
            ''
              runHook preInstall

              # Install the complete Lake package tree.  $out/ IS the
              # package directory — source, lakefile, and pre-built
              # artifacts under .lake/build/.
              cp -rT . "$out"

              # Remove build-environment artifacts that reference the
              # build sandbox or dependency store paths.
              rm -rf "$out/.lake/packages"
              rm -f "$out/.lake/package-overrides.json"

              # Install the setup hook so that downstream derivations
              # (and `nix develop` shells) automatically get this
              # package's oleans in LEAN_PATH.
              mkdir -p "$out/nix-support"
              cp ${./setup-hook.sh} "$out/nix-support/setup-hook"

              # Symlink any built executables into $out/bin/ for
              # discoverability (e.g. packages that are both libraries
              # and executables).
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

              # Install executables only.
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
        # Canonicalize overrideLakeDepsAttrs as an attribute overlay,
        # following the same pattern as buildGoModule's overrideModAttrs.
        overrideLakeDepsAttrs = lib.toExtension overrideLakeDepsAttrs;
      };

      meta = meta // {
        platforms = meta.platforms or lean4.meta.platforms;
      };
    };
}
