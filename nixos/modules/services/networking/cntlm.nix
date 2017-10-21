{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.cntlm;

  configFile = if cfg.configText != "" then
    pkgs.writeText "cntlm.conf" ''
      ${cfg.configText}
    ''
    else
    pkgs.writeText "lighttpd.conf" ''
      # Cntlm Authentication Proxy Configuration
      Username ${cfg.username}
      Domain ${cfg.domain}
      Password ${cfg.password}
      ${optionalString (cfg.netbios_hostname != "") "Workstation ${cfg.netbios_hostname}"}
      ${concatMapStrings (entry: "Proxy ${entry}\n") cfg.proxy}
      ${optionalString (cfg.noproxy != []) "NoProxy ${concatStringsSep ", " cfg.noproxy}"}

      ${concatMapStrings (port: ''
        Listen ${toString port}
      '') cfg.port}

      ${cfg.extraConfig}
    '';

in

{

  options.services.cntlm = {

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
      default = "";
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
      example = [ "proxy.example.com:81" ];
    };

    noproxy = mkOption {
      description = ''
        A list of domains where the proxy is skipped.
      '';
      default = [];
      example = [ "*.example.com" "example.com" ];
    };

    port = mkOption {
      default = [3128];
      description = "Specifies on which ports the cntlm daemon listens.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional config appended to the end of the generated <filename>cntlm.conf</filename>.";
    };

    configText = mkOption {
       type = types.lines;
       default = "";
       description = "Verbatim contents of <filename>cntlm.conf</filename>.";
    };

  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.cntlm = {
      description = "CNTLM is an NTLM / NTLM Session Response / NTLMv2 authenticating HTTP proxy";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "cntlm";
        ExecStart = ''
          ${pkgs.cntlm}/bin/cntlm -U cntlm -c ${configFile} -v -f
        '';
      };
    };

    users.extraUsers.cntlm = {
      name = "cntlm";
      description = "cntlm system-wide daemon";
      isSystemUser = true;
    };
  };
}
