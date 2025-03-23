{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alterware";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "mxve";
    repo = "alterware-launcher";
    rev = "v${finalAttrs.version}";
    sha256 = "1sqh40jhdcbd5nr8lzjqkj4zdg9r2l5cfda3cv6dhwx46qm180gd";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-E3TDgEogpd/YGZnQmre5igxZyZdKQtOx4O4IZEci5II=";

  nativeBuildInputs = [ perl ];

  meta = {
    description = "Official launcher for AlterWare Call of Duty mods";
    homepage = "https://github.com/mxve/alterware-launcher";
    changelog = "https://github.com/mxve/alterware-launcher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ andrewfield ];
    mainProgram = "alterware";
  };
})
