{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  llvmPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_bson";
  version = "26.1100.0";

  src = fetchFromGitHub {
    owner = "Kissaki";
    repo = "nu_plugin_bson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3Uu2YF5fnNvRP4+9GpLYjzZt7lg0kCbBl4bk4l5rEuY=";
  };

  cargoHash = "sha256-iORPlIP9kDLlJkm09SZn2lO3bWcj/Q/g+dBd2CPWiOg=";

  nativeBuildInputs = [
    llvmPackages.libclang
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

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
