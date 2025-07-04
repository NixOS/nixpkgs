{
  lib,
  python3Packages,
  fetchPypi,
  guiSupport ? true,
}:
let
  pname = "plakativ";
  version = "0.5.3";
in
python3Packages.buildPythonApplication {
  format = "setuptools";
  inherit pname version;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6TvMznd5obkn/gsQTyZ6Pc/dF55I53987EbuSNAlY58=";
  };

  dependencies =
    with python3Packages;
    [
      pymupdf
    ]
    ++ lib.optional guiSupport tkinter;

  meta = {
    description = "Convert a PDF into a large poster that can be printed on multiple smaller pages";
    mainProgram = "plakativ";
    homepage = "https://gitlab.mister-muffin.de/josch/plakativ";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ marcin-serwin ];
  };
}
