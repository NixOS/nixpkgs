{ stdenv, fetchFromGitHub, python2, cdparanoia, cdrdao, flac
, sox, accuraterip-checksum, utillinux, substituteAll }:

python2.pkgs.buildPythonApplication rec {
  name = "whipper-${version}";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "whipper-team";
    repo = "whipper";
    rev = "v${version}";
    sha256 = "17cn11c6c62pfhhp6vcslxpanb0czh2xbxq1g6wd7bpmgw38yd8v";
  };

  pythonPath = with python2.pkgs; [
    pygobject3 musicbrainzngs urllib3 chardet
    pycdio setuptools mutagen CDDB
    requests
  ];

  checkInputs = with python2.pkgs; [
    twisted
  ];

  patches = [
    (substituteAll {
      src = ./paths.patch;
      inherit cdparanoia;
    })
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" "${stdenv.lib.makeBinPath [ accuraterip-checksum cdrdao utillinux flac sox ]}"
  ];

  # some tests require internet access
  # https://github.com/JoeLametta/whipper/issues/291
  doCheck = false;

  preCheck = ''
    HOME=$TMPDIR
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/whipper-team/whipper;
    description = "A CD ripper aiming for accuracy over speed";
    maintainers = with maintainers; [ rycee jgeerds ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
