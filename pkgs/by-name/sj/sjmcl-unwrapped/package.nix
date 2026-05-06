{
  lib,
  stdenv,
  cargo-tauri,
  fetchFromGitHub,
  fetchNpmDeps,
  nix-update-script,
  nodejs,
  npmHooks,
  pkg-config,
  rustPlatform,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sjmcl-unwrapped";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "UNIkeEN";
    repo = "SJMCL";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+Ok+AuPvn1OSL6lBGd3x4AIOvjc2YAExUM8RmCydfck=";
  };

  cargoHash = "sha256-cn2xpMshREAmHfV0Lv4cSXwctzSNLk9AR4a50xu0j7E=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-tP8qJc/e2pVK7XbUWoAGIbhrKN8MnWEwKCodfBBC2bU=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoTestFlags = [
    # skip doctests (doc examples are not compilable code)
    "--lib"
    "--bins"
    "--tests"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Minecraft launcher from SJTU Minecraft Club";
    homepage = "https://mc.sjtu.cn/sjmcl";
    changelog = "https://github.com/UNIkeEN/SJMCL/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mx6436 ];
    mainProgram = "SJMCL";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
