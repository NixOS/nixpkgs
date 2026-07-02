{
  stdenv,
  lib,
  python3,
  fetchPypi,
  ffmpeg,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "sigal";
  version = "2.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version pname;
    hash = "sha256-IOAQ6lMudYH+Ukx27VKbPNKmQKBaX3j0p750nC5Y1Hg=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    # install_requires
    jinja2
    markdown
    pillow
    pilkit
    click
    blinker
    natsort
    # extras_require
    brotli
    feedgenerator
    zopfli
    cryptography
  ];

  nativeCheckInputs = [
    ffmpeg
  ]
  ++ (with python3.pkgs; [
    pytestCheckHook
  ]);

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    "test_nonmedia_files"
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}"
  ];

  meta = {
    description = "Yet another simple static gallery generator";
    mainProgram = "sigal";
    homepage = "http://sigal.saimon.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
