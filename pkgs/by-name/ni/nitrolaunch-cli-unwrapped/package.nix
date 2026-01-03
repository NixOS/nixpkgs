{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nitrolaunch-cli";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "Nitrolaunch";
    repo = "nitrolaunch";
    tag = finalAttrs.version;
    hash = "sha256-RUJmnSOQwrN/8KPQiJBER77RDHZIjVHrLgTB2V8wXPc=";
  };

  cargoHash = "sha256-ZkqitSl5vcHU4COYyCVIwWPS1JU4IRtIQ7O81r8gORU=";
  buildType = "fast_release";

  cargoBuildFlags = [
    "--package"
    "nitro_cli"
  ];

  meta = with lib; {
    description = "Fast, extensible, and powerful Minecraft launcher";
    homepage = "https://github.com/Nitrolaunch/nitrolaunch";
    license = licenses.gpl3;
    mainProgram = "nitro";
    maintainers = with maintainers; [ squawkykaka ];
  };
})
