{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "mp3cat";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "tomclegg";
    repo = pname;
    rev = version;
    sha256 = "0n6hjg2wgd06m561zc3ib5w2m3pwpf74njv2b2w4sqqh5md2ymfr";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  installTargets = [
    "install_bin"
  ];

  meta = with lib; {
    description = "Command line program which concatenates MP3 files";
    longDescription = ''
      A command line program which concatenates MP3 files, mp3cat
      only outputs MP3 frames with valid headers, even if there is extra garbage
      in its input stream
    '';
    homepage = "https://github.com/tomclegg/mp3cat";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.omnipotententity ];
    platforms = platforms.all;
    mainProgram = "mp3cat";
  };
}
