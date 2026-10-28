{
  lib,
  b4,
  melpaBuild,
}:
melpaBuild {
  pname = "b4-review-mode";
  inherit (b4) version;

  src = b4.src-misc;
  sourceRoot = "${b4.src-misc.name}/misc/emacs";

  meta = {
    description = "Emacs major mode with highlighting for the b4 review reply editor";
    homepage = "https://git.kernel.org/pub/scm/utils/b4/b4.git/about";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fzakaria ];
  };
}
