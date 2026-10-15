{
  lib,
  fetchFromGitHub,
  replaceVars,
  python3Packages,
  mpv,
}:

python3Packages.buildPythonApplication {
  version = "0.2";
  pyproject = true;
  pname = "curseradio";

  src = fetchFromGitHub {
    owner = "chronitis";
    repo = "curseradio";
    rev = "1bd4bd0faeec675e0647bac9a100b526cba19f8d";
    hash = "sha256-ESEqVaenW/LBvjFz4vchy2iSEwookdsu7E5AJK0EboU=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    requests
    lxml
    pyxdg
  ];

  patches = [
    (replaceVars ./mpv.patch {
      inherit mpv;
    })
  ];

  # No tests
  doCheck = false;

  meta = {
    description = "Command line radio player";
    mainProgram = "curseradio";
    homepage = "https://github.com/chronitis/curseradio";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eyjhb ];
  };
}
