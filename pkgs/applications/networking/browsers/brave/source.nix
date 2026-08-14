{
  lib,
  fetchFromGitHub,
  fetchgit,
  fetchNpmDeps,
  gclient2nix,
  pkgs,
}:
let
  lock = lib.importJSON ./source-lock.json;

  chromiumInfo = if pkgs == null then { } else (lib.importJSON ./chromium-info.json).chromium;

  _chromiumRevCheck =
    if pkgs == null then
      true
    else
      lib.assertMsg (chromiumInfo.DEPS.src.rev == lock.chromium.rev)
        "brave-origin lock chromium rev (${lock.chromium.rev}) must match nixpkgs chromium info.json (${chromiumInfo.DEPS.src.rev})";

  braveOverlayEntries = lib.filterAttrs (name: _value: name != "src") (
    lib.importJSON ./gclient-deps.json
  );

  braveCore =
    if fetchFromGitHub == null then
      null
    else
      fetchFromGitHub {
        inherit (lock.braveCore)
          owner
          repo
          rev
          hash
          ;
      };

  braveNpmDeps =
    if fetchNpmDeps == null || fetchFromGitHub == null then
      null
    else
      fetchNpmDeps {
        name = "brave-core-npm-deps";
        src = braveCore;
        hash = lock.braveCore_npm_hash;
        forceGitDeps = true;
      };

  # Upstream WDP lockfile omits most `resolved` URLs; ship a regenerated
  # lock so fetchNpmDeps / offline `npm ci` can work.
  webDiscoveryProjectSrc =
    if pkgs == null then
      null
    else
      let
        raw =
          (gclient2nix.importGclientDeps braveOverlayEntries)."src/brave/vendor/web-discovery-project".path;
      in
      pkgs.runCommand "web-discovery-project-with-lock" { } ''
        mkdir -p $out
        cp -a ${raw}/. $out/
        chmod -R u+w $out
        cp ${./web-discovery-project.package-lock.json} $out/package-lock.json
      '';

  webDiscoveryProjectNpmDeps =
    if fetchNpmDeps == null || webDiscoveryProjectSrc == null then
      null
    else
      fetchNpmDeps {
        name = "web-discovery-project-npm-deps";
        src = webDiscoveryProjectSrc;
        hash = lock.webDiscoveryProject_npm_hash;
      };

  webDiscoveryProjectRev =
    (lib.importJSON ./gclient-deps.json)."src/brave/vendor/web-discovery-project".args.rev;

  leoSrc =
    if fetchFromGitHub == null then
      null
    else
      fetchFromGitHub {
        inherit (lock.leo)
          owner
          repo
          rev
          hash
          ;
      };

  leoNpmDeps =
    if fetchNpmDeps == null || leoSrc == null then
      null
    else
      fetchNpmDeps {
        name = "brave-leo-npm-deps";
        src = leoSrc;
        hash = lock.leo_npm_hash;
      };

  # @brave/leo prepare generates tokens/skia/*.h; Brave installs leo as a
  # github dep without its build-time node_modules, so build tokens here.
  leoTokens =
    if pkgs == null || leoSrc == null || leoNpmDeps == null then
      null
    else
      pkgs.stdenv.mkDerivation {
        name = "brave-leo-tokens";
        src = leoSrc;
        nativeBuildInputs = [
          pkgs.nodejs
          pkgs.prefetch-npm-deps
        ];
        buildPhase = ''
          runHook preBuild
          export HOME="$TMPDIR"
          export NIX_NODEJS_BUILDNPMPACKAGE=1
          export prefetchNpmDeps="${lib.getExe pkgs.prefetch-npm-deps}"
          export CACHE_MAP_PATH="$TMP/leo-npm-map"
          npmDeps="${leoNpmDeps}" prefetch-npm-deps --map-cache
          npmDeps="${leoNpmDeps}" prefetch-npm-deps --fixup-lockfile "$PWD/package-lock.json"
          cp -r "${leoNpmDeps}" "$TMPDIR/leo-npm-cache"
          chmod -R 700 "$TMPDIR/leo-npm-cache"
          export npm_config_cache="$TMPDIR/leo-npm-cache"
          export npm_config_offline=true
          export npm_config_progress=false
          npm ci --ignore-scripts
          patchShebangs node_modules
          # Full prepare equivalent: tokens/skia + icons-skia (+ rollup outputs).
          npm run build
          runHook postBuild
        '';
        installPhase = ''
          runHook preInstall
          mkdir -p "$out"
          cp -a tokens icons-skia "$out/"
          # Rollup emits shared/web-components/types; genReactBindings emits react/.
          for d in web-components shared build types react; do
            if [ -d "$d" ]; then
              cp -a "$d" "$out/"
            fi
          done
          runHook postInstall
        '';
      };

  depotTools =
    if fetchgit == null || pkgs == null then
      null
    else
      fetchgit {
        url = "https://chromium.googlesource.com/chromium/tools/depot_tools";
        inherit (chromiumInfo.deps.depot_tools) rev hash;
      };

in
{
  inherit
    lock
    chromiumInfo
    braveOverlayEntries
    braveCore
    braveNpmDeps
    webDiscoveryProjectSrc
    webDiscoveryProjectNpmDeps
    webDiscoveryProjectRev
    leoTokens
    depotTools
    ;

  gclientDeps = gclient2nix.importGclientDeps ./gclient-deps.json;

  braveOverlayDeps = gclient2nix.importGclientDeps braveOverlayEntries;
}
