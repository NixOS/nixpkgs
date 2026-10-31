{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cd-discid";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "taem";
    repo = "cd-discid";
    tag = finalAttrs.version;
    hash = "sha256-HHpqMRJr4PkmKgqGTyr8JSErcnQ2jwBqyCr4MvDoP68=";
  };

  installFlags = [
    "PREFIX=$(out)"
    "INSTALL=install"
  ];

  meta = {
    homepage = "https://github.com/taem/cd-discid";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    description = "Command-line utility to get CDDB discid information from a CD-ROM disc";
    mainProgram = "cd-discid";

    longDescription = ''
      cd-discid is a backend utility to get CDDB discid information
      from a CD-ROM disc.  It was originally designed for cdgrab (now
      abcde), but can be used for any purpose requiring CDDB data.
    '';
  };
})
