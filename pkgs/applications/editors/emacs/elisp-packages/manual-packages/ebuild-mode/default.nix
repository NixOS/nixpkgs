{ lib, trivialBuild, fetchurl }:

trivialBuild rec {
  pname = "ebuild-mode";
  version = "1.64";

  src = fetchurl {
    url = "https://dev.gentoo.org/~ulm/emacs/${pname}-${version}.tar.xz";
    sha256 = "sha256-ewn8pFuuXrNzkh7UKWa71Tc3hGM11iqjU9AVNOKSHKA=";
  };

  meta = with lib; {
    description = "Major modes for Gentoo package files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qyliss ];
  };
}
