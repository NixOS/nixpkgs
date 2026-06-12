{
  stdenv,
  pnpm,
  lib,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  nodejs,
  rustPlatform,
  cargo,
  dump_syms,
  python3,
  xcodebuild,
  cctools,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "node-sqlcipher";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "node-sqlcipher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RzuyUx0WEG8j8HwV5cepVJIeqYzJpNemFNtB+9NETto=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm; # may be different than top-level pnpm
    fetcherVersion = 4;
    hash = "sha256-HK3AetwGqFq/dhxX+aWgUww6eLCeQEkZIVsmmnYqdmM=";
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
    pnpmBuildHook
    pnpm
    rustPlatform.cargoSetupHook
    cargo
    dump_syms
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcodebuild
    cctools.libtool
  ];

  preBuild = ''
    export npm_config_nodedir=${nodejs}

    pnpm run prebuildify --strip false --arch "${stdenv.hostPlatform.node.arch}" --platform "${stdenv.hostPlatform.node.platform}"
  '';

  pnpmBuildScript = "build";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r dist $out
    cp -r prebuilds $out
    cp package.json $out

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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    hasNoMaintainersButDependents = true;
  };
})
