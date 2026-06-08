{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pandoc-imagine";
  version = "0.1.7";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "imagine";
    owner = "hertogp";
    tag = finalAttrs.version;
    hash = "sha256-IJAXrJakKjROF2xi9dsLvGzyGIyB+GDnx/Z7BRlwSqc=";
  };

  propagatedBuildInputs = with python3Packages; [
    pandocfilters
    six
  ];

  # No tests in archive
  doCheck = false;

  meta = {
    homepage = finalAttrs.src.meta.homepage;
    description = ''
      A pandoc filter that will turn code blocks tagged with certain classes
      into images or ASCII art
    '';
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
    mainProgram = "pandoc-imagine";
  };
})
