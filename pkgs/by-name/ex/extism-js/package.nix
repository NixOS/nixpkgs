{
  fetchFromGitHub,
  lib,
  pkg-config,
  pkgsCross,
  rustPlatform,
  versionCheckHook,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "extism-js";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "extism";
    repo = "js-pdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CLyH0gDtw988cTcw4B86/kejfbYWMXEVG9Y6PKAZazE=";
  };

  cargoHash = "sha256-9lFX+Q4318ClVIRT4/uCesyNYwU9H2vV+fD3553M2Dc=";

  # https://github.com/extism/js-pdk/pull/154
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail '1.5.1' '${finalAttrs.version}'
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    zstd
  ];

  # fs-set-times v0.20.3 uses #![feature]
  env.RUSTC_BOOTSTRAP = 1;

  env.EXTISM_ENGINE_PATH = "${pkgsCross.wasi32.extism-js-core}/bin/js_pdk_core.wasm";
  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  cargoBuildFlags = [ "--package=js-pdk-cli" ];
  cargoTestFlags = [ "--package=js-pdk-cli" ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    changelog = "https://github.com/extism/js-pdk/releases/tag/v${finalAttrs.version}";
    description = "Write Extism plugins in JavaScript & TypeScript";
    homepage = "https://github.com/extism/js-pdk";
    license = lib.licenses.bsd3;
    mainProgram = "extism-js";
    maintainers = [
      lib.maintainers.diogotcorreia
      lib.maintainers.dotlambda
    ];
    platforms = lib.platforms.unix;
  };
})
