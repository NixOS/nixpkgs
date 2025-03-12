{
  stdenv,
  lib,
  python3,
  fetchPypi,
  ffmpeg,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sigal";
  version = "2.4";
  pyproject = true;

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-pDTaqtqfuk7tACkyaKClTJotuVcTKli5yx1wbEM93TM=";
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

  nativeCheckInputs =
    [
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

  meta = with lib; {
    description = "Yet another simple static gallery generator";
    mainProgram = "sigal";
    homepage = "http://sigal.saimon.org/";
    license = licenses.mit;
    maintainers = with maintainers; [
      domenkozar
      matthiasbeyer
    ];
  };
}
