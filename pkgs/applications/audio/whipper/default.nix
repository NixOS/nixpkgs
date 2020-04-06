{ stdenv, fetchFromGitHub, python3, cdparanoia, cdrdao, flac
, sox, accuraterip-checksum, libsndfile, utillinux, substituteAll }:

python3.pkgs.buildPythonApplication rec {
  pname = "whipper";
  version = "0.9.1.dev7+g${stdenv.lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "whipper-team";
    repo = "whipper";
    rev = "9e95f0604fa30ab06445fe46e3bc93bba6092a05";
    sha256 = "1c2qldw9vxpvdfh5wl6mfcd7zzz3v8r86ffqll311lcp2zin33dg";
  };

  pythonPath = with python3.pkgs; [
    musicbrainzngs
    mutagen
    pycdio
    pygobject3
    requests
    ruamel_yaml
    setuptools
    setuptools_scm
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
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
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
