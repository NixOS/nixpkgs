{ lib, trivialBuild, fetchurl }:

trivialBuild rec {
  pname = "ebuild-mode";
  version = "1.65";

  src = fetchurl {
    url = "https://dev.gentoo.org/~ulm/emacs/${pname}-${version}.tar.xz";
    sha256 = "sha256-vJ+UlPMIuZ02da9R67wIq2dVaWElu/sYmWx2KgBQ9B8=";
  };

  meta = with lib; {
    description = "Major modes for Gentoo package files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qyliss ];
  };
}
