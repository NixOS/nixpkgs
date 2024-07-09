{ lib
, trivialBuild
, urweb
, cl-lib
, flycheck
}:

trivialBuild {
  pname = "urweb-mode";

  inherit (urweb) src version;

  packageRequires = [
    cl-lib
    flycheck
  ];

  postUnpack = ''
    sourceRoot=$sourceRoot/src/elisp
  '';

  meta = {
    description = "Major mode for editing Ur/Web";
    inherit (urweb.meta) license homepage;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
