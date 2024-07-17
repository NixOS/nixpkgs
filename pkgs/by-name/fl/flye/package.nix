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
}:

python3Packages.buildPythonApplication rec {
  pname = "flye";
  version = "2.9.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fenderglass";
    repo = "flye";
    rev = "refs/tags/${version}";
    hash = "sha256-lwiY0VTEsLMMXt1VowsS3jj44v30Z766xNRwQtQKr10=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/mikolmogorov/Flye/pull/691
      name = "aarch64-fix.patch";
      url = "https://github.com/mikolmogorov/Flye/commit/e4dcc3fdf0fa1430a974fcd7da31b03ea642df9b.patch";
      hash = "sha256-Ny2daPt8eYOKnwZ6bdBoCcFWhe9eiIHF4vJU/occwU0=";
    })
    (fetchpatch {
      # https://github.com/mikolmogorov/Flye/pull/711
      name = "remove-distutils.patch";
      url = "https://github.com/mikolmogorov/Flye/commit/fb34f1ccfdf569d186a4ce822ee18eced736636b.patch";
      hash = "sha256-52bnZ8XyP0HsY2OpNYMU3xJgotNVdQc/O2w3XIReUdQ=";
    })
    (fetchpatch {
      # https://github.com/mikolmogorov/Flye/pull/670
      name = "remove-find_module.patch";
      url = "https://github.com/mikolmogorov/Flye/commit/441b1c6eb0f60b7c4fb1a40d659c7dabb7ad41b6.patch";
      hash = "sha256-RytFIN1STK33/nvXpck6woQcwV/e1fmA8AgmptiIiDU=";
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

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    description = "De novo assembler for single molecule sequencing reads using repeat graphs";
    homepage = "https://github.com/fenderglass/Flye";
    license = licenses.bsd3;
    mainProgram = "flye";
    maintainers = with maintainers; [ assistant ];
  };
}
