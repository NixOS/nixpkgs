{ lib, options, ... }:

let superOptions = options; in

{
  options.submodule = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [
        ({ lib, ... }: {
          options.super.enable = lib.mkSuperOptionAlias (superOptions.enable or null);
        })
      ];
    };
  };
}
