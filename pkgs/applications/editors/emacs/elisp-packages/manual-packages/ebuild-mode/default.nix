<<<<<<< HEAD
{ lib, melpaBuild, fetchurl, writeText }:

melpaBuild rec {
  pname = "ebuild-mode";
  version = "1.65";

  src = fetchurl {
    url = "https://dev.gentoo.org/~ulm/emacs/${pname}-${version}.tar.xz";
    sha256 = "sha256-vJ+UlPMIuZ02da9R67wIq2dVaWElu/sYmWx2KgBQ9B8=";
  };

  commit = "not-used-but-has-to-be-set";

  recipe = writeText "recipe" ''
    (ebuild-mode
      :url "https://anongit.gentoo.org/git/proj/ebuild-mode.git"
      :fetcher git)
  '';

=======
{ lib, trivialBuild, fetchurl }:

trivialBuild rec {
  pname = "ebuild-mode";
  version = "1.63";

  src = fetchurl {
    url = "https://dev.gentoo.org/~ulm/emacs/${pname}-${version}.tar.xz";
    sha256 = "sha256-Ar11zz0IVMu0g9+PN9dXvj8yeKnUGi8M+CTJfGP3bd4=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Major modes for Gentoo package files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qyliss ];
  };
}
