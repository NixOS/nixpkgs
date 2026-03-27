{
  lib,
  fetchFromGitHub,
  gitUpdater,
  python3Packages,
  gnutar,
  unzip,
  lhasa,
  rpm,
  binutils,
  cpio,
  gzip,
  p7zip,
  cabextract,
  unrar,
  unshield,
  bzip2,
  xz,
  lzip,
  unzipSupport ? false,
  unrarSupport ? false,
}:

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

  makeWrapperArgs =
    let
      archivers = lib.makeBinPath (
        [
          gnutar
          lhasa
          rpm
          binutils
          cpio
          gzip
          p7zip
          cabextract
          unshield
          bzip2
          xz
          lzip
        ]
        ++ lib.optional unzipSupport unzip
        ++ lib.optional unrarSupport unrar
      );
    in
    [
      ''--prefix PATH : "${archivers}"''
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
