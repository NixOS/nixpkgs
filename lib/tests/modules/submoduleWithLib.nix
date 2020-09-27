{ lib, ... }: {
  options.submodule = lib.mkOption {
    default = {};
    type = lib.types.submoduleWith {
      evalModules = ((import ../..).extend (self: super: { value = 10; })).evalModules;
      modules = [ ({ lib, ... }: {
        options.value = lib.mkOption {
          default = lib.value;
        };
      })];
    };
  };
}
