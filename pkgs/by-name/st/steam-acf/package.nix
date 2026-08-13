{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "steam-acf";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "chisui";
    repo = "acf";
    rev = "v${finalAttrs.version}";
    sha256 = "16q3md7cvdz37pqm1sda81rkjf249xbsrlpdl639r06p7f4nqlc2";
  };

  cargoHash = "sha256-3BbSTzFcQju0n7pwFqvrJB2sU8RM47Svi4lndlhkYmE=";

  meta = {
    description = "Tool to convert Steam .acf files to JSON";
    homepage = "https://github.com/chisui/acf";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ chisui ];
    mainProgram = "acf";
  };
})
