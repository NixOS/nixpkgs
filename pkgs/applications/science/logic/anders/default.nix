{ lib, fetchFromGitHub, ocamlPackages }:

ocamlPackages.buildDunePackage rec {
  pname = "anders";
  version = "1.1.1";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "groupoid";
    repo = "anders";
<<<<<<< HEAD
    rev = version;
=======
    rev = "${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sha256 = "sha256-JUiZoo2rNLfgs94TlJqUNzul/7ODisCjSFAzhgSp1z4=";
  };

  strictDeps = true;

  nativeBuildInputs = [ ocamlPackages.menhir ];
  buildInputs = [ ocamlPackages.zarith ];

  meta = with lib; {
    description = "Modal Homotopy Type System";
    homepage = "https://homotopy.dev/";
    license = licenses.isc;
    maintainers = [ maintainers.suhr ];
  };
}
