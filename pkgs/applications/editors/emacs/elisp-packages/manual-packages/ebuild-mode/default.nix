{ lib, melpaBuild, fetchurl, writeText }:

melpaBuild rec {
  pname = "ebuild-mode";
  version = "1.67";

  src = fetchurl {
    url = "https://dev.gentoo.org/~ulm/emacs/ebuild-mode-${version}.tar.xz";
    hash = "sha256-5qxHpu1BLtI8LFnL/sAoqmo80zeyElxIdFtAsfMefUE=";
  };

  # not used but needs to be set; why?
  commit = "e7b45096283ac8836f208babddfd1ea1c1d1d1d";

  recipe = writeText "recipe" ''
    (ebuild-mode
      :url "https://anongit.gentoo.org/git/proj/ebuild-mode.git"
      :fetcher git)
  '';

  meta = {
    homepage = "https://gitweb.gentoo.org/proj/ebuild-mode.git/";
    description = "Major modes for Gentoo package files";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ qyliss ];
  };
}
