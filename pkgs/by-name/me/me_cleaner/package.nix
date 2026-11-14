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
    hash = "sha256-RPamgHP2vQcsF4wWJcOBrzDdgUFbH7sDITmOUCkTsq0=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  meta = {
    inherit (src.meta) homepage;
    description = "Tool for partial deblobbing of Intel ME/TXE firmware images";
    longDescription = ''
      me_cleaner is a Python script able to modify an Intel ME firmware image
      with the final purpose of reducing its ability to interact with the system.
    '';
    license = lib.licenses.gpl3;
    maintainers = [ ];
    mainProgram = "me_cleaner.py";
  };
}
