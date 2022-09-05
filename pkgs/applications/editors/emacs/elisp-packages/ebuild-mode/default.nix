{ lib, trivialBuild, fetchurl }:

trivialBuild rec {
  pname = "ebuild-mode";
  version = "1.60";

  src = fetchurl {
    url = "https://dev.gentoo.org/~ulm/emacs/${pname}-${version}.tar.xz";
    sha256 = "sha256-XN+RLVff4yvxjaAuNjUgSOzU0KdnVGMt9B78rfW389g=";
  };

  meta = with lib; {
    description = "Major modes for Gentoo package files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qyliss ];
  };
}
