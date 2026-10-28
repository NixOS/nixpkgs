{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  python3,
  autoPatchelfHook,
  makeWrapper,
  stdenv,
  sqlite,
  nixosTests,
}:
let
  version = "2.4.0";

  flameSrc = fetchFromGitHub {
    owner = "pawelmalak";
    repo = "flame";
    tag = "v${version}";
    hash = "sha256-Slnft/tDtogjuTnQXus0Mp7y6AlOYjCV1riQ2M9cIc8=";
  };

  clientDeps = fetchNpmDeps {
    pname = "flame-client-deps";
    inherit version;
    src = flameSrc + "/client";
    hash = "sha256-IitL0qxu6/3y9x8XkW0dZLjsHTkNeQMHYsaq/LOwvrg=";
  };
in
buildNpmPackage (finalAttrs: {
  pname = "flame";
  inherit version;
  __structuredAttrs = true;

  src = flameSrc;

  nativeBuildInputs = [
    python3
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    sqlite
  ];

  npmFlags = [ "--build-from-source" ];

  npmDepsHash = "sha256-YGusqgF8xU6QBB0r0M8V0UZHLuSTdYlYyIMXnov7YEA=";

  dontNpmBuild = true;

  postPatch = ''
    cat > db/migrations/01_new-config.js <<'EOF'
    // Neutered for the Nix/NixOS package: this migration only exists to
    // migrate pre-2.0 SQL-table-based config into config.json for very
    // old installs. Fresh installs never have that legacy `config`
    // table, and its unconditional copy of the default config template
    // over data/config.json would clobber declarative settings applied
    // by the NixOS module on every first boot.
    const up = async () => {};
    const down = async () => {};
    module.exports = { up, down };
    EOF
  '';

  buildPhase = ''
    runHook preBuild

    cd client
    npm ci --cache ${clientDeps} --offline
    patchShebangs node_modules
    npm run build
    cd -

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/flame/{data,public}
    cp -r . $out/lib/flame
    cp -r client/build/. $out/lib/flame/public
    rm -r $out/lib/flame/client

    makeWrapper ${lib.getExe' nodejs "node"} $out/bin/flame \
      --add-flags $out/lib/flame/server.js

    runHook postInstall
  '';

  passthru.tests = {
    nixos = nixosTests.flame;
  };

  meta = {
    description = "Self-hosted startpage for your server";
    homepage = "https://github.com/pawelmalak/flame";
    license = lib.licenses.mit;
    mainProgram = "flame";
    maintainers = with lib.maintainers; [ DerGrumpf ];
  };
})
