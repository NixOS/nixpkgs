{ vimUtils, mirth }:

vimUtils.buildVimPlugin {
  pname = "mirth";
  inherit (mirth) version;
  src = "${mirth.src}/tools/mirth-vim";
  meta = {
    inherit (mirth.meta) homepage license;
    description = "Syntax highlighting & filetype detection for the Mirth programming language";
  };
}
