{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  llvmPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_bson";
  version = "26.1110.0";

  src = fetchFromGitHub {
    owner = "Kissaki";
    repo = "nu_plugin_bson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nvL4xQoBSGzY1vSlhAwgfK/ZyGEBxg4y/oVhrKguUbs=";
  };

  cargoHash = "sha256-6o3viJquyKQWwayV8wSXQCSkOOcrun2EHLP5r5WefjA=";

  nativeBuildInputs = [
    llvmPackages.libclang
  ];

  env.LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  passthru.update-script = nix-update-script { };
  meta = {
    description = " Nushell plugin for BSON (Binary JSON) format `from bson` and `to bson`";
    homepage = "https://github.com/Kissaki/nu_plugin_bson";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "nu_plugin_bson";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
