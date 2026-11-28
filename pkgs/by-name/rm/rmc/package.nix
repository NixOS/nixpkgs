{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rmc";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ricklupton";
    repo = "rmc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9KEvKJ9D82cpLsR+yfvtd+yVp8ZPs2A9ZFFnzSfWDXg=";
  };

  # rmscene version bump
  patches = [
    (fetchpatch {
      url = "https://github.com/ricklupton/rmc/commit/2bd483657d8f0fa945b60486de093580fb9aea62.patch";
      hash = "sha256-Wf2cGDQZa9E/AJo2xGt3oPOuBhXriD76G/0jU7/SD/I=";
    })
  ];

  build-system = [ python3Packages.poetry-core ];

  dependencies = [
    python3Packages.rmscene
    python3Packages.click
  ];

  meta = {
    description = "Command line tool for converting to/from remarkable .rm version 6 (software version 3) files.";
    homepage = "https://github.com/ricklupton/rmc";
    license = lib.licenses.mit;
    mainProgram = "rmc";
    maintainers = [ lib.maintainers.quantenzitrone ];
  };
})
