{
  cargo-about,
  cargo-tauri,
  fetchFromGitHub,
  fetchNpmDeps,
  glib-networking,
  lib,
  libsoup_3,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  wrapGAppsHook4,
  webkitgtk_4_1,
}:
let
  subdir = "vrc-get-gui";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alcom";
  version = "1.1.6";
  src = fetchFromGitHub {
    owner = "vrc-get";
    repo = "vrc-get";
    tag = "gui-v${finalAttrs.version}";
    hash = "sha256-TpVHE3e3dMdBOtPVKomKvg5tQf42QWik18k5oVD2Hms=";
  };

  nativeBuildInputs = [
    cargo-about
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    libsoup_3
    makeBinaryWrapper
    webkitgtk_4_1
  ];

  cargoHash = "sha256-J8vCr+B4J3ZqxkkNk+x0jr52qNJJYfBJe2oyLf0GLsc=";
  buildFeatures = [ "no-self-updater" ];
  buildAndTestSubdir = subdir;

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/${subdir}";
    hash = "sha256-VyA2c2659Kg1DjLmmtvSAivltdraSBNArIu1XGENGmQ=";
  };
  npmRoot = subdir;

  meta = {
    description = "Experimental GUI application to manage VRChat Unity Projects";
    homepage = "https://github.com/vrc-get/vrc-get";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Scrumplex
      ImSapphire
    ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "ALCOM";
  };
})
