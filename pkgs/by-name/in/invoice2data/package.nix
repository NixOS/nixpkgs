{
  lib,
  fetchFromGitHub,
  fetchpatch,
  ghostscript,
  imagemagick,
  poppler-utils,
  python3,
  tesseract5,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "invoice2data";
  version = "0.4.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "invoice-x";
    repo = "invoice2data";
    rev = "v${version}";
    hash = "sha256-pAvkp8xkHYi/7ymbxaT7/Jhu44j2P8emm8GyXC6IBnI=";
  };

  patches = [
    # https://github.com/invoice-x/invoice2data/pull/522
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/invoice-x/invoice2data/commit/ccea3857c7c8295ca51dc24de6cde78774ea7e64.patch";
      hash = "sha256-BhqPW4hWG/EaR3qBv5a68dcvIMrCCT74GdDHr0Mss5Q=";
    })
  ];

  build-system = with python3.pkgs; [
    setuptools
    setuptools-git
  ];

  dependencies = with python3.pkgs; [
    dateparser
    pdfminer-six
    pillow
    pyyaml
    setuptools # pkg_resources is imported during runtime
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      ghostscript
      imagemagick
      tesseract5
      poppler-utils
    ])
  ];

  # Tests fails even when ran manually on my ubuntu machine !!
  doCheck = false;

  pythonImportsCheck = [
    "invoice2data"
  ];

  meta = with lib; {
    description = "Data extractor for PDF invoices";
    mainProgram = "invoice2data";
    homepage = "https://github.com/invoice-x/invoice2data";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
