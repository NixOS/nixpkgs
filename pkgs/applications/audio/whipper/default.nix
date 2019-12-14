{ stdenv, fetchFromGitHub, python3, cdparanoia, cdrdao, flac
, sox, accuraterip-checksum, libsndfile, utillinux, substituteAll }:

python3.pkgs.buildPythonApplication rec {
  pname = "whipper";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "whipper-team";
    repo = "whipper";
    rev = "v${version}";
    sha256 = "0x1qsp021i0l5sdcm2kcv9zfwp696k4izhw898v6marf8phll7xc";
  };

  pythonPath = with python3.pkgs; [
    pygobject3 musicbrainzngs urllib3 chardet
    pycdio setuptools setuptools_scm mutagen
    requests
  ];

  buildInputs = [ libsndfile ];

  checkInputs = with python3.pkgs; [
    twisted
  ];

  patches = [
    (substituteAll {
      src = ./paths.patch;
      inherit cdparanoia;
    })
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (stdenv.lib.makeBinPath [ accuraterip-checksum cdrdao utillinux flac sox ])
  ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="v${version}"
  '';

  # some tests require internet access
  # https://github.com/JoeLametta/whipper/issues/291
  doCheck = false;

  preCheck = ''
    HOME=$TMPDIR
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/whipper-team/whipper;
    description = "A CD ripper aiming for accuracy over speed";
    maintainers = with maintainers; [ rycee emily ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
