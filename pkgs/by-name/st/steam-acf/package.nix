{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "steam-acf";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "chisui";
    repo = "acf";
    rev = "v${version}";
    sha256 = "16q3md7cvdz37pqm1sda81rkjf249xbsrlpdl639r06p7f4nqlc2";
  };

  cargoHash = "sha256-3BbSTzFcQju0n7pwFqvrJB2sU8RM47Svi4lndlhkYmE=";

<<<<<<< HEAD
  meta = {
    description = "Tool to convert Steam .acf files to JSON";
    homepage = "https://github.com/chisui/acf";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ chisui ];
=======
  meta = with lib; {
    description = "Tool to convert Steam .acf files to JSON";
    homepage = "https://github.com/chisui/acf";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ chisui ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "acf";
  };
}
