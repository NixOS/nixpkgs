{ lib, trivialBuild, fetchurl }:

trivialBuild rec {
  pname = "ebuild-mode";
  version = "1.63";

  src = fetchurl {
    url = "https://dev.gentoo.org/~ulm/emacs/${pname}-${version}.tar.xz";
    sha256 = "sha256-Ar11zz0IVMu0g9+PN9dXvj8yeKnUGi8M+CTJfGP3bd4=";
  };

  meta = with lib; {
    description = "Major modes for Gentoo package files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qyliss ];
  };
}
