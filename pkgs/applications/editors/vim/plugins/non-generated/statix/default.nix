{
  vimUtils,
  statix,
}:
vimUtils.buildVimPlugin rec {
  inherit (statix) pname src meta;
  version = "0.1.0";
  postPatch = ''
    # check that version is up to date
    grep 'pname = "statix-vim"' -A 1 flake.nix \
      | grep -F 'version = "${version}"'

    cd vim-plugin
    substituteInPlace ftplugin/nix.vim --replace-fail statix ${statix}/bin/statix
    substituteInPlace plugin/statix.vim --replace-fail statix ${statix}/bin/statix
  '';
}
