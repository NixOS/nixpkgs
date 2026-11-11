{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  udev,
  udevCheckHook,
  webkitgtk_4_1,
  wrapGAppsHook4,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sharkfin";
  version = "0.11.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dniminenn";
    repo = "sharkfin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qrjIn41fvCElqQtOrZxQzqlwFMAPxbms6atXlsaigR0=";
  };

  cargoRoot = "app/src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-qPRMT0RRpHs4qFfdKSFfaLEHyKVftAsCNfZaHbTRFws=";

  npmRoot = "app";
  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/app";
    hash = "sha256-G8LLnJiAS9Qqv5ECPcq2HtoN+RlCEwoV5lpV4dRtJ9k=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udev
    webkitgtk_4_1
  ];

  doInstallCheck = true;

  # Upstream does not specify a bundle category.
  postPatch = ''
    substituteInPlace app/src-tauri/tauri.conf.json \
      --replace-fail '"targets": "all",' '"targets": "all", "category": "Utility",'
  '';

  nativeInstallCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udevCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Configurator for Attack Shark and other ROYUAN keyboards";
    homepage = "https://getsharkfin.com/";
    changelog = "https://github.com/dniminenn/sharkfin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "sharkfin";
    maintainers = [ lib.maintainers.jancopieters ];
  };
})
