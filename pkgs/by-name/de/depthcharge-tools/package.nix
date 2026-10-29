{
  bzip2,
  dtc,
  fetchFromGitLab,
  gzip,
  lib,
  lz4,
  lzop,
  makeWrapper,
  nix-update-script,
  python3Packages,
  ubootTools,
  vboot-utils,
  xz,
  zstd,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "depthcharge-tools";
  version = "0.6.4";
  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "depthcharge-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-McnBtc0UpatKO4XBnMOHf2L8xxcrsRM/5DCbmAmfA1o=";
  };

  pyproject = true;
  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    importlib-resources
    importlib-metadata
    packaging
  ];

  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    "${lib.makeBinPath [
      bzip2
      dtc
      gzip
      lz4
      lzop
      ubootTools
      vboot-utils
      xz
      zstd
    ]}"
  ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Tools to manage the Chrome OS bootloader";
    homepage = "https://gitlab.postmarketos.org/postmarketOS/depthcharge-tools";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.ninelore ];
    mainProgram = "depthchargectl";
  };
})
