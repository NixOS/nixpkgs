{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  libdvdread,
  libdvdcss,
  dvdauthor,
}:

stdenv.mkDerivation rec {
  version = "0.4.2";
  pname = "dvdbackup";

  src = fetchurl {
    url = "mirror://sourceforge/dvdbackup/${pname}-${version}.tar.xz";
    sha256 = "1rl3h7waqja8blmbpmwy01q9fgr5r0c32b8dy3pbf59bp3xmd37g";
  };

  buildInputs = [
    libdvdread
    libdvdcss
    dvdauthor
  ];

  # see https://bugs.launchpad.net/dvdbackup/+bug/1869226
  patchFlags = [ "-p0" ];
  patches = [
    (fetchpatch {
      url = "https://git.slackbuilds.org/slackbuilds/plain/multimedia/dvdbackup/patches/dvdbackup-dvdread-6.1.patch";
      sha256 = "1v3xl01bwq1592i5x5dyh95r0mmm1zvvwf92fgjc0smr0k3davfz";
    })
  ];

  meta = {
    description = "Tool to rip video DVDs from the command line";
    homepage = "https://dvdbackup.sourceforge.net/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.bradediger ];
    platforms = lib.platforms.linux;
    mainProgram = "dvdbackup";
  };
}
