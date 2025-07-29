{
  lib,
  fetchFromSourcehut,
  python3Packages,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "mymcplus";
  version = "3.0.5";
  pyproject = true;

  src = fetchFromSourcehut {
    owner = "~thestr4ng3r";
    repo = "mymcplus";
    rev = "v${version}";
    sha256 = "sha256-GFReOgM8zi5oyePpJm5HxtizUVqqUUINTRwyG/LGWB8=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pyopengl
    wxpython
  ];

  pythonImportsCheck = [ "mymcplus" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~thestr4ng3r/mymcplus";
    description = "PlayStation 2 memory card manager";
    mainProgram = "mymcplus";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
