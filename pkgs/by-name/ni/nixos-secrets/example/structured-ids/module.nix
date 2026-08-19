{ lib, ... }:
let
  hashId = id: toString (builtins.hashString "md5" (builtins.toJSON id));
in
{
  options.secrets.idHasher = lib.mkOption {
    type = lib.types.functionTo lib.types.str;
    default = hashId;
    readOnly = true;
  };

  options.secrets.generators = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { config, ... }:
        {
          options.id = lib.mkOption {
            type = lib.types.json;
            description = "A freeform ID that can be used to identify the generator";
            example = {
              foo = 1;
              goo = 2;
            };
          };

          config.name = hashId config.id;
        }
      )
    );
  };
}
