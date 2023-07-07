{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.23.0";
    hash = "sha256-WZe1fJ6H+h7QcXn+gR7OJ+KSOgd9NxTDLMs7UOFeq70=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.24.0-beta.1";
    hash = "sha256-tA1xsgtAeOn0c0HcZutj+Pqrsr0JV5bQOnknH4t/QkY=";
  };
}
