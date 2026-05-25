{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "s2png";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = "s2png";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-BRVubGy5GpP0zhJ26DXBwlqflfZTnLVfhQk5qFj29x4=";
  };

  cargoHash = "sha256-aka4q3Wh0s1iaIUJkPuL/2FnJH5KdbpOOWLIAWirBFk=";

  meta = {
    homepage = "https://github.com/dbohdan/s2png/";
    description = "Store any data in PNG images";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      dbohdan
      kybe236
    ];
    platforms = lib.platforms.unix;
    mainProgram = "s2png";
  };
})
