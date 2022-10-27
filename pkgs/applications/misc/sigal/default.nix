{ stdenv
, lib
, python3
, ffmpeg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sigal";
  version = "2.3";
  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    inherit version pname;
    hash = "sha256-4Zsb/OBtU/jV0gThEYe8bcrb+6hW+hnzQS19q1H409Q=";
  };

  patches = [ ./copytree-permissions.patch ];

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

    setuptools # needs pkg_resources
  ];

  checkInputs = [
    ffmpeg
  ] ++ (with python3.pkgs; [
    pytestCheckHook
  ]);

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_nonmedia_files"
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}"
  ];

  meta = with lib; {
    description = "Yet another simple static gallery generator";
    homepage = "http://sigal.saimon.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ domenkozar matthiasbeyer ];
  };
}
