{ vimUtils, mirth }:

vimUtils.buildVimPlugin {
  pname = "mirth";
  inherit (mirth) version;
  src = mirth.vim;
  meta = {
    inherit (mirth.meta)
      homepage
      license
      platforms
      ;
    description = "Syntax highlighting & filetype detection for the Mirth programming language";
  };
}
