{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nitrolaunch-cli";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "Nitrolaunch";
    repo = "nitrolaunch";
    tag = finalAttrs.version;
    hash = "sha256-QnmC8BmMKr7M206Np6Dafe8T04iZGIbkY4Lzj3TlUyE=";
  };

  cargoHash = "sha256-Hm7mRpY8Jrem1HgMJw+3aosGOGDEnmWI88SjpAyhOpk=";
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
