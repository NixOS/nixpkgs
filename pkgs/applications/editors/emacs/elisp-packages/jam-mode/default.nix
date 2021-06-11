{ trivialBuild, lib, fetchurl }:

trivialBuild rec {
  pname = "jam-mode";
  version = "0.3";

  src = fetchurl {
    url = "https://dev.gentoo.org/~ulm/distfiles/jam-mode-${version}.el.xz";
    sha256 = "1jchgiy2rgvnb3swr6ar72yas6pj4inpgpcq78q01q6snflmi2fh";
  };

  unpackPhase = ''
    xz -cd $src > jam-mode.el
  '';

  meta = with lib; {
    description = "An Emacs major mode for editing Jam files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.all;
  };
}
