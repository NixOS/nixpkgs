{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alterware-launcher";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "alterware";
    repo = "alterware-launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DFIiVNYom3LvU9IFA9w9FvXwm9gqfACDs8KaFKQR9Qs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/2i6GyBTKLf2oNFkizaBUHcLcCPgsy3g0p31D6cO+xg=";

  nativeBuildInputs = [ perl ];

  meta = {
    description = "Official launcher for AlterWare Call of Duty mods";
    longDescription = "Our clients are designed to restore missing features that have been removed by the developers, as well as enhance the capabilities of the games";
    homepage = "https://alterware.dev";
    changelog = "https://github.com/alterware/alterware-launcher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ andrewfield ];
    mainProgram = "alterware-launcher";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
