{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonPackage rec {
  pname = "rectangle-packer";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Penlect";
    repo = "rectangle-packer";
    rev = version;
    hash = "sha256-YsMLB9jfAC5yB8TnlY9j6ybXM2ILireOgQ8m8wYo4ts=";
  };

  nativeBuildInputs = with python3Packages; [ setuptools ];
  propagatedBuildInputs = with python3Packages; [ cython ];

  meta = with lib; {
    description = "A library for packing rectangles into a rectangle with minimum size";
    homepage = "https://github.com/Penlect/rectangle-packer/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ annaaurora ];
  };
}
