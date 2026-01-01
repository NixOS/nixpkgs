{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "shellharden";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "anordal";
    repo = "shellharden";
    rev = "v${version}";
    sha256 = "sha256-aBX3RXfDhlXVMV8aPO0pu3527nDoYrUDUbH6crWO/W8=";
  };

  cargoHash = "sha256-kMY+esMOsQZC979jntcqF35KVJCBuNLXHb0WYOV5YHA=";

  postPatch = "patchShebangs moduletests/run";

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Corrective bash syntax highlighter";
    mainProgram = "shellharden";
    longDescription = ''
      Shellharden is a syntax highlighter and a tool to semi-automate the
      rewriting of scripts to ShellCheck conformance, mainly focused on quoting.
    '';
    homepage = "https://github.com/anordal/shellharden";
<<<<<<< HEAD
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ oxzi ];
=======
    license = licenses.mpl20;
    maintainers = with maintainers; [ oxzi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
