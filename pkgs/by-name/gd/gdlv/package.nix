{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gdlv";
<<<<<<< HEAD
  version = "1.15.0";
=======
  version = "1.12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "aarzilli";
    repo = "gdlv";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-YHv/PfkQh0detM3p62oDWhEG8PWCupaBhwbxz8rHRdI=";
=======
    hash = "sha256-6NU7bhURdXM4EjVnsXVf9XFOUgHyVEI0kr15q9OnUTQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = null;
  subPackages = ".";

<<<<<<< HEAD
  meta = {
    description = "GUI frontend for Delve";
    mainProgram = "gdlv";
    homepage = "https://github.com/aarzilli/gdlv";
    maintainers = with lib.maintainers; [ mmlb ];
    license = lib.licenses.gpl3;
=======
  meta = with lib; {
    description = "GUI frontend for Delve";
    mainProgram = "gdlv";
    homepage = "https://github.com/aarzilli/gdlv";
    maintainers = with maintainers; [ mmlb ];
    license = licenses.gpl3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
