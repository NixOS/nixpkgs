{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  gdbm, # ndbm.h for dupemap binary
  perl,
}:

stdenv.mkDerivation {
  pname = "magicrescue";
  version = "1.1.10-unstable-2021-09-12";

  src = fetchFromGitHub {
    owner = "jbj";
    repo = "magicrescue";
    rev = "d9a57931d437674009bfd2f98451b3d71058eade";
    hash = "sha256-jVBzsa39TQjeDZ4zuXn3UA+4WectjNRwPNb1AkLuIbg=";
  };

  patches = [
    # Add PERL as processor for file.
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/magicrescue/-/raw/6331d088a159ae21ad4ab5f18b9bf892ebe18ce3/debian/patches/020_add-Perl-preprocessor.patch";
      hash = "sha256-XX3Rlv/qKB2y/csuaPiliv4cu9KKHNpG/E88VSVP0sg=";
    })
  ];

  buildInputs = [
    gdbm
    perl
  ];

  meta = with lib; {
    description = "Find and recover deleted files on block devices";
    mainProgram = "magicrescue";
    homepage = "https://github.com/jbj/magicrescue";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
