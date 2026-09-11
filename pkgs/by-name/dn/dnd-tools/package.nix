{
  python3,
  fetchFromGitLab,
  fetchpatch,
  lib,
}:

python3.pkgs.buildPythonApplication {
  pname = "dnd-tools";
  version = "0-unstable-2022-08-01";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "savagezen";
    repo = "dnd-tools";
    rev = "faa09f6c01de423c4e592126e24ad929f8a9f164";
    hash = "sha256-Ues2T3kSVA0/+gBlszZVjGPZMkgIE1Vy0Dy9ZBrpgAg=";
  };

  # gives warning every time unless patched, see https://github.com/savagezen/dnd-tools/pull/20
  patches = [
    (fetchpatch {
      url = "https://gitlab.com/savagezen/dnd-tools/-/commit/0443f3a232056ad67cfb09eb3eadcb6344659198.patch";
      sha256 = "00k8rsz2aj4sfag6l313kxbphcb5bjxb6z3aw66h26cpgm4kysp0";
    })
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  meta = {
    homepage = "https://gitlab.com/savagezen/dnd-tools";
    description = "Set of interactive command line tools for Dungeons and Dragons 5th Edition";
    mainProgram = "dnd-tools";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
  };
}
