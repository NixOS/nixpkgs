{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "me_cleaner";
  version = "1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "corna";
    repo = "me_cleaner";
    rev = "v${version}";
    sha256 = "1bdj2clm13ir441vn7sv860xsc5gh71ja5lc2wn0gggnff0adxj4";
  };

  build-system = with python3.pkgs; [ setuptools ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (src.meta) homepage;
    description = "Tool for partial deblobbing of Intel ME/TXE firmware images";
    longDescription = ''
      me_cleaner is a Python script able to modify an Intel ME firmware image
      with the final purpose of reducing its ability to interact with the system.
    '';
<<<<<<< HEAD
    license = lib.licenses.gpl3;
=======
    license = licenses.gpl3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "me_cleaner.py";
  };
}
