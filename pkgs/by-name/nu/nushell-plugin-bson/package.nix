{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  llvmPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_bson";
  version = "26.1121.1";

  src = fetchFromGitHub {
    owner = "Kissaki";
    repo = "nu_plugin_bson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GByQCBtvFoC6Fn8qyFkXXDsUbsOLjag55SC7toUmc4c=";
  };

  cargoHash = "sha256-DjvvaLYyfqgFo+G071YgViAgBfLCm9M0z/vyS+azLfU=";

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
