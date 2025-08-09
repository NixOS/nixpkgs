{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "muffet";
  version = "2.10.9";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    rev = "v${version}";
    hash = "sha256-I4xLa4R9vxP+bHa1wP4ci5r4ZIlH2KUif+udSVLUsNk=";
  };

  vendorHash = "sha256-scma8hrm8e/KU2x+TIGOvaUk6nYxKIZ1eaGqs/W2I0I=";

  meta = {
    description = "Website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "muffet";
  };
}
