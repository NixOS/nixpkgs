let
  lib = import ./lib;
  nixos = import ./nixos/lib/eval-config.nix {
    system = builtins.currentSystem;
    modules = [ ];
    declarationLocations = true;
  };

  testEm = lib.evalModules {
    declarationLocations = true;
    modules = [
      ({ ... }: {
        options = {
          nya.nya = lib.mkOption {
            description = "nya!";
            type = lib.types.int;
          };
          nya.nyaaa = lib.mkOption {
            description = "nyaaaaa!";
            type = lib.types.int;
          };
        };
      })
    ];
  };

  locationToTagLine = name: loc:
    # XXX: clearly we are getting some funny data for submodules.
    # but i dont care. maybe it should be fixed.
    let line = if loc ? line then loc.line else 1;
    in
    if loc != null then
    "${name}\t${loc.file}\t${toString line}\n"
    else "";

  toTags = acc0: struct: (builtins.foldl'
    (acc: name:
      let item = struct.${name}; in
      if item ? _type && item._type == "option" then
        acc ++ builtins.map (locationToTagLine (builtins.toString item)) item.declarationsWithLocations
      else toTags acc item
    ) acc0
    (builtins.attrNames struct));
in
{
  inherit nixos lib testEm;
  tags = builtins.concatStringsSep "" (builtins.sort builtins.lessThan (toTags [] nixos.options));
  dl = lib.optionAttrSetToDocList nixos.options;
}
