{
  vimUtils,
  fzf,
}:
# Mainly used as a dependency for fzf-vim. Wraps the fzf program as a vim
# plugin, since part of the fzf vim plugin is included in the main fzf
# program.
vimUtils.buildVimPlugin {
  inherit (fzf) src version;
  pname = "fzf";
  postInstall = ''
    ln -s ${fzf}/bin/fzf $target/bin/fzf
  '';
}
