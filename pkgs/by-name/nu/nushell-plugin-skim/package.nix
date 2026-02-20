{
  stdenv,
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_skim";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "idanarye";
    repo = "nu_plugin_skim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CWjds0AWYwrKk1sgBSOalEIYJd2Aymc6XK22Bd9QLuo=";
  };

  cargoHash = "sha256-mucbl0ow0FjNiDL1BNKT7BMVpMKvmKEz3dP6/9BBRV4=";

  nativeBuildInputs = lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin that adds integrates the skim fuzzy finder";
    mainProgram = "nu_plugin_skim";
    homepage = "https://github.com/idanarye/nu_plugin_skim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aftix ];
  };
})
