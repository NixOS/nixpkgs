{
  stdenv,
  lib,
  rustPlatform,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_skim";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "idanarye";
    repo = "nu_plugin_skim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C/zrDKNGbAgxkKknm3uQ/x/EPjEIpX+eFZkdnLOdF+Q=";
  };

  cargoHash = "sha256-d7/VVebNaj5Vys/aYb2z02eCwklOcYm0zxH9AczUHdc=";

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
