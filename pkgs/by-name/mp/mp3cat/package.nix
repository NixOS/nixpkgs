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
    repo = "mp3cat";
    rev = version;
    sha256 = "0n6hjg2wgd06m561zc3ib5w2m3pwpf74njv2b2w4sqqh5md2ymfr";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  installTargets = [
    "install_bin"
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Command line program which concatenates MP3 files";
    longDescription = ''
      A command line program which concatenates MP3 files, mp3cat
      only outputs MP3 frames with valid headers, even if there is extra garbage
      in its input stream
    '';
    homepage = "https://github.com/tomclegg/mp3cat";
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.omnipotententity ];
    platforms = lib.platforms.all;
=======
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.omnipotententity ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "mp3cat";
  };
}
