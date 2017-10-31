{ config, lib, ... }:

let
  inherit (lib) mkOption mkIf types mapAttrsToList;
  cfg = config.programs.dconf;

  mkDconfProfile = name: path:
    { source = path; target = "dconf/profile/${name}"; };

in
{
  ###### interface

  options = {
    programs.dconf = {

      profiles = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = "Set of dconf profile files.";
        internal = true;
      };

    };
  };

  ###### implementation

  config = mkIf (cfg.profiles != {}) {
    environment.etc =
      (mapAttrsToList mkDconfProfile cfg.profiles);
  };

}
