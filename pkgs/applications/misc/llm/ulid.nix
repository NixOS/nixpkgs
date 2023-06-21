{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonPackage rec {
  pname = "python-ulid";
  version = "1.1.0";

  src = fetchPypi rec {
    inherit pname version;
    sha256 = "sha256-X7XkqR24ypPok4phM2Cz3vKZtg1B+Ecnmow5ybLpxl4=";
  };

  propagatedBuildInputs = [
    python3Packages.setuptools
    python3Packages.pytest
    python3Packages.freezegun
  ];

  preBuild = ''
        cat > setup.py << EOF
    from setuptools import setup

    if __name__ == "__main__":
      setup()
    EOF
  '';
}
