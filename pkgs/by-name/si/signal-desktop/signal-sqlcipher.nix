{
  stdenv,
  lib,
  fetchFromGitHub,
  pnpm,
  nodejs,
  rustPlatform,
  cargo,
  dump_syms,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "node-sqlcipher";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "node-sqlcipher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JYdc3H8PhDLkJH5ApfReq0e7HgKoJaK01JGuzoqftyc=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-regaYG+SDvIgdnHQVR1GG1A1FSBXpzFfLuyTEdMt1kQ=";
  };

  cargoRoot = "deps/extension";
  cargoDeps = rustPlatform.fetchCargoVendor {
    name = "sqlcipher-signal-exentsion";
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-qT4HM/FRL8qugKKNlMYM/0zgUsC6cDOa9fgd1d4VIrc=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    rustPlatform.cargoSetupHook
    cargo
    dump_syms
    python3
  ];

  buildPhase = ''
    runHook preBuild

    export npm_config_nodedir=${nodejs}
    pnpm run prebuildify
    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out
    cp -r prebuilds $out

    runHook postInstall
  '';

  meta = {
    description = "Fast N-API-based Node.js addon wrapping sqlcipher and FTS5 segmenting APIs";
    homepage = "https://github.com/signalapp/node-sqlcipher/tree/main";
    license = with lib.licenses; [
      agpl3Only

      # deps/sqlcipher
      bsd3
    ];
    platforms = lib.platforms.linux;
  };
})
