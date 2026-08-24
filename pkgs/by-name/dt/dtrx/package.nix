{
  arj,
  binutils-unwrapped,
  brotli,
  bzip2,
  cabextract,
  cpio,
  dtrx,
  fetchFromGitHub,
  gitUpdater,
  gnutar,
  gzip,
  lhasa,
  lib,
  lrzip,
  lzip,
  p7zip,
  python3Packages,
  rpm,
  unrar,
  unshield,
  unzip,
  xz,
  zstd,
  arjSupport ? false,
  unrarSupport ? false,
  unzipSupport ? false,
}:
let
  archivers = [
    binutils-unwrapped
    brotli
    bzip2
    cabextract
    cpio
    gnutar
    gzip
    lhasa
    lrzip
    lzip
    p7zip
    rpm
    unshield
    xz
    zstd
  ]
  ++ lib.optional arjSupport arj
  ++ lib.optional unrarSupport unrar
  ++ lib.optional unzipSupport unzip;
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "dtrx";
  version = "8.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dtrx-py";
    repo = "dtrx";
    rev = finalAttrs.version;
    sha256 = "sha256-FNSFEGIK0vDNlvqc8BKDCB/0hoxrITfeh59JcyzX3jY=";
  };

  makeWrapperArgs = [
    ''--prefix PATH : "${lib.makeBinPath archivers}"''
  ];

  build-system = [
    python3Packages.setuptools
  ];

  nativeCheckInputs = archivers ++ [
    python3Packages.pyaml
  ];

  postPatch = ''
    patchShebangs --build tests/compare.py
  '';

  checkPhase = ''
    runHook preCheck
    tests/compare.py '^(?!download and extract$)(?!password zip noninteractive$).*'
    runHook postCheck
  '';

  doCheck = arjSupport && unrarSupport && unzipSupport;

  passthru.updateScript = gitUpdater { };
  passthru.tests.dtrx-full = dtrx.override {
    arjSupport = true;
    unrarSupport = true;
    unzipSupport = true;
  };

  meta = {
    description = "Do The Right Extraction: A tool for taking the hassle out of extracting archives";
    homepage = "https://github.com/dtrx-py/dtrx";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ colinsane ];
    mainProgram = "dtrx";
  };
})
