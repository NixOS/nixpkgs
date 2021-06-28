{ lib, trivialBuild, fetchurl }:

trivialBuild rec {
  pname = "ebuild-mode";
  version = "1.52";

  src = fetchurl {
    url = "https://dev.gentoo.org/~ulm/emacs/ebuild-mode-${version}.tar.xz";
    sha256 = "10nikbbwh612qlnms2i31963a0h3ccyg85vrxlizdpsqs4cjpg6h";
  };

  meta = with lib; {
    description = "Major modes for Gentoo package files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qyliss ];
  };
}
