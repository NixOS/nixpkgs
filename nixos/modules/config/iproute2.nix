{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.iproute2;
in
{
  options.networking.iproute2 = {
    enable = mkEnableOption "copy IP route configuration files";
    rttablesExtraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Verbatim lines to add to /etc/iproute2/rt_tables
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.etc."iproute2/bpf_pinning" = { mode = "0644"; text = fileContents "${pkgs.iproute2}/etc/iproute2/bpf_pinning"; };
    environment.etc."iproute2/ematch_map"  = { mode = "0644"; text = fileContents "${pkgs.iproute2}/etc/iproute2/ematch_map";  };
    environment.etc."iproute2/group"       = { mode = "0644"; text = fileContents "${pkgs.iproute2}/etc/iproute2/group";       };
    environment.etc."iproute2/nl_protos"   = { mode = "0644"; text = fileContents "${pkgs.iproute2}/etc/iproute2/nl_protos";   };
    environment.etc."iproute2/rt_dsfield"  = { mode = "0644"; text = fileContents "${pkgs.iproute2}/etc/iproute2/rt_dsfield";  };
    environment.etc."iproute2/rt_protos"   = { mode = "0644"; text = fileContents "${pkgs.iproute2}/etc/iproute2/rt_protos";   };
    environment.etc."iproute2/rt_realms"   = { mode = "0644"; text = fileContents "${pkgs.iproute2}/etc/iproute2/rt_realms";   };
    environment.etc."iproute2/rt_scopes"   = { mode = "0644"; text = fileContents "${pkgs.iproute2}/etc/iproute2/rt_scopes";   };
    environment.etc."iproute2/rt_tables"   = { mode = "0644"; text = (fileContents "${pkgs.iproute2}/etc/iproute2/rt_tables")
                                                                   + (optionalString (cfg.rttablesExtraConfig != "") "\n\n${cfg.rttablesExtraConfig}"); };
  };
}
