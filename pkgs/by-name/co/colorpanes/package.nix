{
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage rec {
  pname = "colorpanes";
  version = "3.0.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "colorpanes";
    rev = "v${version}";
    sha256 = "qaOH+LXNDq+utwyI1yzHWNt25AvdAXCTAziGV9ElroU=";
  };

  cargoHash = "sha256-+ltcTuLksNwe7KIt8apYNZkMoA2w4EObG5dhJliRb6Y=";

  postInstall = ''
    ln -s $out/bin/colp $out/bin/colorpanes
  '';

<<<<<<< HEAD
  meta = {
    description = "Panes in the 8 bright terminal colors with shadows of the respective darker color";
    homepage = "https://codeberg.org/annaaurora/colorpanes";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ annaaurora ];
=======
  meta = with lib; {
    description = "Panes in the 8 bright terminal colors with shadows of the respective darker color";
    homepage = "https://codeberg.org/annaaurora/colorpanes";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ annaaurora ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
