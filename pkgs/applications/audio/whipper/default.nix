{ lib
, python3
, fetchFromGitHub
, libcdio-paranoia
, cdrdao
, libsndfile
, flac
, sox
, util-linux
}:

let
  bins = [ libcdio-paranoia cdrdao flac sox util-linux ];
in python3.pkgs.buildPythonApplication rec {
  pname = "whipper";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "whipper-team";
    repo = "whipper";
    rev = "v${version}";
    sha256 = "00cq03cy5dyghmibsdsq5sdqv3bzkzhshsng74bpnb5lasxp3ia5";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools_scm
    docutils
  ];

  propagatedBuildInputs = with python3.pkgs; [
    musicbrainzngs
    mutagen
    pycdio
    pygobject3
    ruamel_yaml
    discid
    pillow
  ];

  buildInputs = [ libsndfile ];

  checkInputs = with python3.pkgs; [
    twisted
  ] ++ bins;

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath bins)
  ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
  '';

  checkPhase = ''
    runHook preCheck
    # disable tests that require internet access
    # https://github.com/JoeLametta/whipper/issues/291
    substituteInPlace whipper/test/test_common_accurip.py \
      --replace "test_AccurateRipResponse" "dont_test_AccurateRipResponse"
    HOME=$TMPDIR ${python3.interpreter} -m unittest discover
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/whipper-team/whipper";
    description = "A CD ripper aiming for accuracy over speed";
    maintainers = with maintainers; [ emily ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
