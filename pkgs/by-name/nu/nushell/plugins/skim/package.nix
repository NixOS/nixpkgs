{
  stdenv,
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_skim";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "idanarye";
    repo = "nu_plugin_skim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FYA34MmRW5UyhwHe3ODkMtGTrTTZhYdI1jAHvGmWPQw=";
  };

  cargoHash = "sha256-bC87fTJXiz7avteNS83iITXgNsx453zhNpPj4ANYvbM=";

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
