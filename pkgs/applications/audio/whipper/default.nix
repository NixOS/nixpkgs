{ stdenv, fetchFromGitHub, python2, cdparanoia, cdrdao, flac
, sox, accuraterip-checksum, utillinux, substituteAll }:

python2.pkgs.buildPythonApplication rec {
  name = "whipper-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "JoeLametta";
    repo = "whipper";
    rev = "v${version}";
    sha256 = "04m8s0s9dcnly9l6id8vv99n9kbjrjid79bss52ay9yvwng0frmj";
  };

  pythonPath = with python2.pkgs; [
    pygobject2 musicbrainzngs urllib3 chardet
    pycdio setuptools mutagen
    requests
  ];

  checkInputs = with python2.pkgs; [
    twisted
  ];

  patches = [
    (substituteAll {
      src = ./paths.patch;
      inherit cdrdao cdparanoia utillinux flac sox;
      accurateripChecksum = accuraterip-checksum;
    })
  ];

  # some tests require internet access
  # https://github.com/JoeLametta/whipper/issues/291
  doCheck = false;

  preCheck = ''
    HOME=$TMPDIR
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/JoeLametta/whipper;
    description = "A CD ripper aiming for accuracy over speed";
    maintainers = with maintainers; [ rycee jgeerds ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
