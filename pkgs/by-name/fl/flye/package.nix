{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
  zlib,
  curl,
  libdeflate,
  bash,
  coreutils,
  addBinToPathHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "flye";
  version = "2.9.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mikolmogorov";
    repo = "flye";
    tag = finalAttrs.version;
    hash = "sha256-ESxJdFGxLLKP/A/E3ve7rgFADeDmSldhZsm99cpR58k=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/mikolmogorov/Flye/pull/691
      name = "aarch64-fix.patch";
      url = "https://github.com/mikolmogorov/Flye/commit/e4dcc3fdf0fa1430a974fcd7da31b03ea642df9b.patch";
      hash = "sha256-Ny2daPt8eYOKnwZ6bdBoCcFWhe9eiIHF4vJU/occwU0=";
    })
  ];

  postPatch = ''
    substituteInPlace flye/polishing/alignment.py \
      --replace-fail "/bin/bash" "${lib.getExe bash}"
  '';

  build-system = [ python3Packages.setuptools ];

  propagatedBuildInputs = [ coreutils ];

  buildInputs = [
    zlib
    curl
    libdeflate
  ];

  pythonImportsCheck = [ "flye" ];

  nativeCheckInputs = [
    addBinToPathHook
    python3Packages.pytestCheckHook
  ];

  meta = {
    description = "De novo assembler for single molecule sequencing reads using repeat graphs";
    homepage = "https://github.com/mikolmogorov/Flye";
    license = lib.licenses.bsd3;
    mainProgram = "flye";
    maintainers = with lib.maintainers; [ assistant ];
  };
})
