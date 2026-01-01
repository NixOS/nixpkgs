{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule {
  pname = "solitaire-tui";
  version = "0-unstable-2023-04-20";

  src = fetchFromGitHub {
    owner = "brianstrauch";
    repo = "solitaire-tui";
    rev = "45fffc4b13dbf1056f25a01c612dd835ddab5501";
    hash = "sha256-xbqKtqFVvL+1x/SDoMEJ1LgnTy31LmZ/Je8K/bhP2bI=";
  };

  vendorHash = "sha256-jFbxT0ekimBNjIHGgMmCUrwZTS3Sdop/MFQMVdBF/38=";

  ldflags = [
    "-s"
    "-w"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/brianstrauch/solitaire-tui";
    description = "Klondike solitaire for the terminal";
    mainProgram = "solitaire-tui";
    maintainers = with lib.maintainers; [ nyadiia ];
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    homepage = "https://github.com/brianstrauch/solitaire-tui";
    description = "Klondike solitaire for the terminal";
    mainProgram = "solitaire-tui";
    maintainers = with maintainers; [ nyadiia ];
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
