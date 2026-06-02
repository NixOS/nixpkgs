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
  version = "2.9.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fenderglass";
    repo = "flye";
    tag = finalAttrs.version;
    hash = "sha256-ZdrAxPKY3+HJ388tGCdpDcvW70mJ5wd4uOUkuufyqK8=";
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
    homepage = "https://github.com/fenderglass/Flye";
    license = lib.licenses.bsd3;
    mainProgram = "flye";
    maintainers = with lib.maintainers; [ assistant ];
  };
})
