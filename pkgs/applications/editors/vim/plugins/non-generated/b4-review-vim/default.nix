{
  lib,
  vimUtils,
  b4,
}:
vimUtils.buildVimPlugin {
  pname = "b4-review-vim";
  inherit (b4) version;

  src = b4.src-misc;
  sourceRoot = "${b4.src-misc.name}/misc/vim";

  meta = {
    description = "Vim syntax highlighting for the b4 review reply editor";
    homepage = "https://git.kernel.org/pub/scm/utils/b4/b4.git/about";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fzakaria ];
  };
}
