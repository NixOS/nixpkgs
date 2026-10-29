{
  lib,
  vimUtils,
  cosh,
  ftdetect ? true,
}:

vimUtils.buildVimPlugin {
  pname = "cosh";
  inherit (cosh) version;
  src = "${cosh.src}/vim";
  patches = [
    # Unescaped pipes, `|`, crashes. Patch emailed.
    ./vim-escape-pipes.diff
  ];
  # Upstream *only* ships syntax/cosh.vim, so providing a minimal ftdetect.
  # Chill is the default detection for *.ch which causes a conflict. If
  # installing the Vim plugin, force cosh by default. Opt out of detection with
  # `let g:cosh_detect_ch = 0` in one’s vimrc or, alternatively,
  # vimPlugins.cosh.override { ftdetect = false; } to entirely disable the file.
  preInstall = lib.optionalString ftdetect /* bash */ ''
    mkdir -p ftdetect
    cat <<EOF >"ftdetect/cosh.vim"
    ${/* vim */ ''
      if get(g:, 'cosh_detect_ch', 1)
        au BufNewFile,BufRead *.ch set filetype=cosh
      endif
    ''}EOF
  '';
  meta = {
    inherit (cosh.meta) homepage license;
    description = "Syntax highlighting & filetype detection for the cosh language";
  };
}
