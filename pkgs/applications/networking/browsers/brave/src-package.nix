{
  lib,
  stdenvNoCC,
  gclient2nix,
}:
let
  lock = lib.importJSON ./source-lock.json;
in
stdenvNoCC.mkDerivation {
  pname = "brave-origin-src";
  inherit (lock) version;

  gclientDeps = gclient2nix.importGclientDeps ./gclient-deps.json;
  sourceRoot = "src";

  nativeBuildInputs = [
    gclient2nix.gclientUnpackHook
  ];

  dontConfigure = true;
  dontBuild = true;
  dontCheckForBrokenSymlinks = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -R . "$out/src"
    chmod -R u+w "$out/src"

    cat > "$out/SOURCE_PROVENANCE.json" <<'EOF'
    ${builtins.toJSON {
      package = "brave-origin-src";
      version = lock.version;
      lockFile = "source-lock.json";
      gclientLock = "gclient-deps.json";
      note = "Materialized from fixed-output fetches; derivation performs no network access.";
    }}
    EOF

    runHook postInstall
  '';

  passthru.lock = lock;

  meta = {
    description = "Pinned Brave Origin source tree (materialization-only)";
    homepage = "https://github.com/brave/brave-browser";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
