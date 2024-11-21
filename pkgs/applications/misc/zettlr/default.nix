{ callPackage }:

builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  zettlr = {
    version = "3.3.1";
    hash = "sha256-jKqe3dEWEtg/SqY2sfgi+AaPOk2fn4tfEMhNDGlJMQw=";
  };
}
