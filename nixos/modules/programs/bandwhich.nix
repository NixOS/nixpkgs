{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.bandwhich;
in
{
<<<<<<< HEAD
=======
  meta.maintainers = with lib.maintainers; [ Br1ght0ne ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  options = {
    programs.bandwhich = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to add bandwhich to the global environment and configure a
          setcap wrapper for it.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ bandwhich ];
    security.wrappers.bandwhich = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_ptrace,cap_dac_read_search,cap_net_raw,cap_net_admin+ep";
      source = "${pkgs.bandwhich}/bin/bandwhich";
    };
  };
}
