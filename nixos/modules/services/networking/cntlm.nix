{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.cntlm;
  uid = config.ids.uids.cntlm;

in

{

  options = {

    services.cntlm = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable the cntlm, which start a local proxy.
        '';
      };

      username = mkOption {
        description = ''
          Proxy account name, without the possibility to include domain name ('at' sign is interpreted literally).
        '';
      };

      domain = mkOption {
        description = ''Proxy account domain/workgroup name.'';
      };

      password = mkOption {
        default = "/etc/cntlm.password";
        type = types.str;
        description = ''Proxy account password. Note: use chmod 0600 on /etc/cntlm.password for security.'';
      };

      netbios_hostname = mkOption {
        type = types.str;
        description = ''
          The hostname of your machine.
        '';
      };

      proxy = mkOption {
        description = ''
          A list of NTLM/NTLMv2 authenticating HTTP proxies.

          Parent proxy, which requires authentication. The same as proxy on the command-line, can be used more than  once  to  specify  unlimited
          number  of  proxies.  Should  one proxy fail, cntlm automatically moves on to the next one. The connect request fails only if the whole
          list of proxies is scanned and (for each request) and found to be invalid. Command-line takes precedence over the configuration file.
        '';
      };

      port = mkOption {
        default = [3128];
        description = "Specifies on which ports the cntlm daemon listens.";
      };

     extraConfig = mkOption {
        default = "";
        description = "Verbatim contents of <filename>cntlm.conf</filename>.";
     };

    };

  };


  ###### implementation

  config = mkIf config.services.cntlm.enable {
    systemd.services.cntlm = {
      description = "CNTLM is an NTLM / NTLM Session Response / NTLMv2 authenticating HTTP proxy";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        User = "cntlm";
        ExecStart = ''
          ${pkgs.cntlm}/bin/cntlm -U cntlm \
            -c ${pkgs.writeText "cntlm_config" cfg.extraConfig}
        '';
      };  
    };
   
    services.cntlm.netbios_hostname = mkDefault config.networking.hostName;
  
    users.extraUsers.cntlm =  { 
      name = "cntlm";
      description = "cntlm system-wide daemon";
      home = "/var/empty";
    };

    services.cntlm.extraConfig =
      ''
        # Cntlm Authentication Proxy Configuration
        Username        ${cfg.username}
        Domain          ${cfg.domain}
        Password        ${cfg.password}
        Workstation     ${cfg.netbios_hostname}
        ${concatMapStrings (entry: "Proxy ${entry}\n") cfg.proxy}
    
        ${concatMapStrings (port: ''
          Listen ${toString port}
        '') cfg.port}
      '';      
  };
  
}
