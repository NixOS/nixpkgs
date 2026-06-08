{
  binutils,
  bzip2,
  cabextract,
  cpio,
  fetchFromGitHub,
  gitUpdater,
  gnutar,
  gzip,
  lhasa,
  lib,
  lzip,
  p7zip,
  python3Packages,
  rpm,
  unrar,
  unshield,
  unzip,
  xz,
  unrarSupport ? false,
  unzipSupport ? false,
}:
let
  archivers = [
    binutils
    bzip2
    cabextract
    cpio
    gnutar
    gzip
    lhasa
    lzip
    p7zip
    rpm
    unshield
    xz
  ]
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

  build-system = with python3Packages; [
    setuptools
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Do The Right Extraction: A tool for taking the hassle out of extracting archives";
    homepage = "https://github.com/dtrx-py/dtrx";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ colinsane ];
    mainProgram = "dtrx";
  };
})
