{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mp3cat";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "tomclegg";
    repo = "mp3cat";
    rev = finalAttrs.version;
    sha256 = "0n6hjg2wgd06m561zc3ib5w2m3pwpf74njv2b2w4sqqh5md2ymfr";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  installTargets = [
    "install_bin"
  ];

  meta = {
    description = "Command line program which concatenates MP3 files";
    longDescription = ''
      A command line program which concatenates MP3 files, mp3cat
      only outputs MP3 frames with valid headers, even if there is extra garbage
      in its input stream
    '';
    homepage = "https://github.com/tomclegg/mp3cat";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.omnipotententity ];
    platforms = lib.platforms.all;
    mainProgram = "mp3cat";
  };
})
