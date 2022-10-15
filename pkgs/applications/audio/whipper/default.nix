{ lib
, python3
, fetchFromGitHub
, fetchpatch
, libcdio-paranoia
, cdrdao
, libsndfile
, flac
, sox
, util-linux
, testers
, whipper
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

  patches = [
    (fetchpatch {
      # Use custom YAML subclass to be compatible with ruamel_yaml>=0.17
      # https://github.com/whipper-team/whipper/pull/543
      url = "https://github.com/whipper-team/whipper/commit/3ce5964dfe8be1e625c3e3b091360dd0bc34a384.patch";
      sha256 = "0n9dmib884y8syvypsg88j0h71iy42n1qsrh0am8pwna63sl15ah";
    })
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
    docutils
    setuptoolsCheckHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    musicbrainzngs
    mutagen
    pycdio
    pygobject3
    ruamel-yaml
    discid
    pillow
    setuptools
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

  preCheck = ''
    # disable tests that require internet access
    # https://github.com/JoeLametta/whipper/issues/291
    substituteInPlace whipper/test/test_common_accurip.py \
      --replace "test_AccurateRipResponse" "dont_test_AccurateRipResponse"
    export HOME=$TMPDIR
  '';

  passthru.tests.version = testers.testVersion {
    package = whipper;
    command = "HOME=$TMPDIR whipper --version";
  };

  meta = with lib; {
    homepage = "https://github.com/whipper-team/whipper";
    description = "A CD ripper aiming for accuracy over speed";
    maintainers = with maintainers; [ emily ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
