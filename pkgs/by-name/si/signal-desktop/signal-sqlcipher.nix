{
  stdenv,
  lib,
  fetchFromGitHub,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  rustPlatform,
  cargo,
  dump_syms,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "node-sqlcipher";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "node-sqlcipher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-70kObW6jYzaquMrj20VMTQg/rDWqIu8o2/m7S3mUZB8=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm; # may be different than top-level pnpm
    fetcherVersion = 1;
    hash = "sha256-regaYG+SDvIgdnHQVR1GG1A1FSBXpzFfLuyTEdMt1kQ=";
  };

  cargoRoot = "deps/extension";
  cargoDeps = rustPlatform.fetchCargoVendor {
    name = "sqlcipher-signal-exentsion";
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-NtJPwRvjU1WsOxgb2vpokes9eL4DkEcbDaEmML7zsqQ=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    rustPlatform.cargoSetupHook
    cargo
    dump_syms
    python3
  ];

  buildPhase = ''
    runHook preBuild

    export npm_config_nodedir=${nodejs}
    pnpm run prebuildify --strip false --arch "${stdenv.hostPlatform.node.arch}" --platform "${stdenv.hostPlatform.node.platform}"
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
