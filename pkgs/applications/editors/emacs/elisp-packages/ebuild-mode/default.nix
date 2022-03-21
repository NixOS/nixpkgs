{ lib, trivialBuild, fetchurl }:

trivialBuild rec {
  pname = "ebuild-mode";
  version = "1.55";

  src = fetchurl {
    url = "https://dev.gentoo.org/~ulm/emacs/${pname}-${version}.tar.xz";
    sha256 = "1bs2s5g79vrbk8544lvp388cdbig0s121kwk0h10hif4kp56ka9w";
  };

  meta = with lib; {
    description = "Major modes for Gentoo package files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qyliss ];
  };
}
