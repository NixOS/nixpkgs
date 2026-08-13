{
  emptyFile,
  nixos,
}:
let
  result = nixos (
    { utils, ... }:
    {
      options = {
        stateRevision1 = utils.mkStateRevisionOption {
          descriptionName = "...";
          migrations = {
            "27.05" = "...";
          };
        };
        stateRevision2 = utils.mkStateRevisionOption {
          descriptionName = "...";
          migrations = {
            "26.11" = "...";
          };
        };
        stateRevision3 = utils.mkStateRevisionOption {
          descriptionName = "...";
          migrations = {
            "24.05" = "...";
            "27.05" = "...";
          };
        };
      };
      config.system.stateVersion = "26.11";
    }
  );
  inherit (result) config options;
in
assert config.stateRevision1 == 0;
assert config.stateRevision2 == 1;
assert config.stateRevision3 == 1;
assert options.stateRevision1.migrations == { "27.05" = "..."; };
emptyFile
