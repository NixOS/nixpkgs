{
  lib,
  melpaBuild,
  urweb,
  cl-lib,
  flycheck,
}:

melpaBuild {
  pname = "urweb-mode";

  inherit (urweb) src version;

  packageRequires = [
    cl-lib
    flycheck
  ];

  files = ''("src/elisp/*.el")'';

  dontConfigure = true;

  meta = {
    description = "Major mode for editing Ur/Web";
    inherit (urweb.meta) license homepage;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
