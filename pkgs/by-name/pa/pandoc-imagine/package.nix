{
  fetchFromGitHub,
  python3Packages,
  lib,
}:

python3Packages.buildPythonApplication rec {
  pname = "pandoc-imagine";
  version = "0.1.7";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "imagine";
    owner = "hertogp";
    rev = version;
    sha256 = "sha256-IJAXrJakKjROF2xi9dsLvGzyGIyB+GDnx/Z7BRlwSqc=";
  };

  propagatedBuildInputs = [
    python3Packages.pandocfilters
    python3Packages.six
  ];

  # No tests in archive
  doCheck = false;

  meta = {
    homepage = src.meta.homepage;
    description = ''
      A pandoc filter that will turn code blocks tagged with certain classes
      into images or ASCII art
    '';
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
    mainProgram = "pandoc-imagine";
  };
}
