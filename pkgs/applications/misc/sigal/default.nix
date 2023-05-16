{ stdenv
, lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ffmpeg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sigal";
  version = "2.3";
  format = "setuptools";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3.pkgs.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  nativeCheckInputs = [
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
