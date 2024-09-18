{ callPackage }:

builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  zettlr = {
    version = "3.2.0";
    hash = "sha256-gttDGWFJ/VmOyqgOSKnCqqPtNTKJd1fmDpa0ZAX3xc8=";
  };
}
