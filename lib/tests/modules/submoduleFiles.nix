{ lib, ... }:
{
  options.submodule = lib.mkOption {
    default = { };
    type = lib.types.submoduleWith {
      modules = [
        (
          { options, ... }:
          {
            options.value = lib.mkOption { };

            options.internalFiles = lib.mkOption {
              default = options.value.files;
            };
          }
        )
      ];
    };
  };

  imports = [
    {
      _file = "the-file.nix";
      submodule.value = 10;
    }
  ];
}
