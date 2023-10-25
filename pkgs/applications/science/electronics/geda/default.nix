{ lib, stdenv, fetchurl, fetchpatch, pkg-config, guile, gtk2, flex, gawk, perl }:

stdenv.mkDerivation {
  pname = "geda";
  version = "1.8.2-20130925";

  src = fetchurl {
    url = "http://ftp.geda-project.org/geda-gaf/stable/v1.8/1.8.2/geda-gaf-1.8.2.tar.gz";
    sha256 = "08dpa506xk4gjbbi8vnxcb640wq4ihlgmhzlssl52nhvxwx7gx5v";
  };

  patches = [
    # Pull upstream patch for -fno-common toolchains
    (fetchpatch {
      name = "fno-common-p1.patch";
      url = "http://git.geda-project.org/geda-gaf/patch/?id=cb6bac898fe43c5a59b577123ba8698ec04deef6";
      sha256 = "0njlh20qjrlqf5m8p92vmkl0jsm747f4mbqwvldnf8nd2j608nkq";
    })
    (fetchpatch {
      name = "fno-common-p2.patch";
      url = "http://git.geda-project.org/geda-gaf/patch/?id=7b9d523a3558290b4487c3ff9a4a5b43e8941158";
      sha256 = "1z9gzz5ngsbq6c9dw2dfz7kpsq97zhs1ma9saxm7hiybwadbj18k";
    })
  ];

  configureFlags = [
    "--disable-update-xdg-database"
  ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ guile gtk2 flex gawk perl ];

  meta = with lib; {
    description = "Full GPL'd suite of Electronic Design Automation tools";
    homepage = "http://www.geda-project.org/";
    maintainers = with maintainers; [ pjones ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
