# To build this derivation, run `nix-build -A nixpkgs-manual.optionsDoc`
{ lib, nixosOptionsDoc }:

let
  modules = lib.evalModules {
    modules = [ ../../pkgs/top-level/config.nix ];
    class = "nixpkgsConfig";
  };

  root = toString ../..;

  transformDeclaration =
    decl:
    let
      resolvedDeclStr = toString (lib.filesystem.resolveDefaultNix decl);
      subpath = lib.removePrefix "/" (lib.removePrefix root resolvedDeclStr);
    in
    assert lib.hasPrefix root resolvedDeclStr;
    {
      url = "https://github.com/NixOS/nixpkgs/blob/master/${subpath}";
      name = subpath;
    };
in
nixosOptionsDoc {
  inherit (modules) options;
  documentType = "none";
  transformOptions = opt: opt // { declarations = map transformDeclaration opt.declarations; };
}
