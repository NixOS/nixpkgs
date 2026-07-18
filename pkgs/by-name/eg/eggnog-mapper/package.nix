{
  lib,
  autoPatchelfHook,
  fetchFromGitHub,
  fetchpatch2,
  python3Packages,
  wget,
  zlib,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "eggnog-mapper";
  version = "2.1.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eggnogdb";
    repo = "eggnog-mapper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rjQojz6JA7T03s4PojjXJuDZhdAx9VhPQrlRTGZaYZg=";
  };

  patches = [
    # From https://github.com/eggnogdb/eggnog-mapper/pull/599
    (fetchpatch2 {
      name = "replace-distutils.patch";
      url = "https://github.com/eggnogdb/eggnog-mapper/commit/998129d3766e060ff450e8f950b5361c6318b0a2.patch?full_index=1";
      hash = "sha256-xYNd9p5BhGpvFXCWXRSEkZf+Lt4hCRGYeV9Oe4mDz3I=";
    })
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  buildInputs = [
    zlib
  ];

  propagatedBuildInputs = [
    wget
  ];

  dependencies = with python3Packages; [
    biopython
    psutil
    xlsxwriter
  ];

  # Upstream already relaxed these dependencies, but that is not yet included in 2.1.14
  pythonRelaxDeps = [
    "biopython"
    "psutil"
    "xlsxwriter"
  ];

  # Tests rely on some of the databases being available, which is not bundled
  # with this package as (1) in total, they represent >100GB of data, and (2)
  # the user can download only those that interest them.
  doCheck = false;

  meta = {
    description = "Fast genome-wide functional annotation through orthology assignment";
    license = lib.licenses.gpl2;
    homepage = "https://github.com/eggnogdb/eggnog-mapper/wiki";
    maintainers = with lib.maintainers; [ luispedro ];
    platforms = lib.platforms.all;
  };
})
