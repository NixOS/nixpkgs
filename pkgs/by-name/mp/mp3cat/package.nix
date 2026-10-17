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
    hash = "sha256-2VUvWi0QY024WGJLS467/I4qeFlxsB9MqQa0x8WT0Fg=";
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
