{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.cntlm;

  needsPassNTLMv2 = builtins.elem cfg.authType ["NTLMv2"];
  needsPassNT = builtins.elem cfg.authType ["NTLM2SR" "NT" "NTLM"];
  needsPassLM = builtins.elem cfg.authType ["NTLM" "LM"];

  buildConfig =
    pkgs.runCommandNoCC "cntlm.conf" {} ''
      set -euo pipefail
      cat ${configPrelude} >$out
      GENERATED=$(echo "${cfg.password}" | ${pkgs.cntlm}/bin/cntlm \
        -u ${cfg.username} -d ${cfg.domain} -H)

      ${lib.optionalString needsPassNTLMv2 ''
        echo "$GENERATED" | grep 'PassNTLMv2 ' >>$out
      ''}
      ${lib.optionalString needsPassNT ''
        echo "$GENERATED" | grep 'PassNT ' >>$out
      ''}
      ${lib.optionalString needsPassLM ''
        echo "$GENERATED" | grep 'PassLM ' >>$out
      ''}
    '';

  configPrelude = pkgs.writeText "cntlm-prelude.conf" ''
    # Cntlm Authentication Proxy Configuration
    Username ${cfg.username}
    Domain ${cfg.domain}
    Auth ${cfg.authType}
    ${lib.optionalString (cfg.netbios_hostname != "") "Workstation ${cfg.netbios_hostname}"}
    ${lib.concatMapStrings (entry: "Proxy ${entry}\n") cfg.proxy}
    ${lib.optionalString (cfg.noproxy != [ ]) "NoProxy ${lib.concatStringsSep ", " cfg.noproxy}"}

    ${lib.concatMapStrings (port: ''
      Listen ${toString port}
    '') cfg.port}

    ${cfg.extraConfig}
  '';

  configFile =
    if cfg.configFile != null then
      cfg.configFile
    else
      buildConfig;
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "cntlm" "configText" ] ''
      Use services.cntlm.configFile in conjunction with a trivial builder, e.g. writeText
    '')
  ];

  options.services.cntlm = {

    enable = lib.mkEnableOption "cntlm, which starts a local proxy";

    username = lib.mkOption {
      type = lib.types.str;
      description = ''
        Proxy account name, without the possibility to include domain name ('at' sign is interpreted literally).
      '';
    };

    domain = lib.mkOption {
      type = lib.types.str;
      description = "Proxy account domain/workgroup name.";
    };

    authType = lib.mkOption {
      type = lib.types.enum [
        "NTLMv2"
        "NTLM2SR"
        "NT"
        "NTLM"
        "LM"
      ];
      description = "Authentication type for the ntlm proxy";
    };

    password = lib.mkOption {
      type = lib.types.str;
      description = ''
        Proxy account password in plaintext. Will be hashed in accordance with the selected authType.
        Note that hashed passwords will be world-readable in the Nix store.
      '';
    };

    netbios_hostname = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        The hostname of your machine.
      '';
    };

    proxy = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        A list of NTLM/NTLMv2 authenticating HTTP proxies.

        Parent proxy, which requires authentication. The same as proxy on the command-line, can be used more than  once  to  specify  unlimited
        number  of  proxies.  Should  one proxy fail, cntlm automatically moves on to the next one. The connect request fails only if the whole
        list of proxies is scanned and (for each request) and found to be invalid. Command-line takes precedence over the configuration file.
      '';
      example = [ "proxy.example.com:81" ];
    };

    noproxy = lib.mkOption {
      description = ''
        A list of domains where the proxy is skipped.
      '';
      default = [ ];
      type = lib.types.listOf lib.types.str;
      example = [
        "*.example.com"
        "example.com"
      ];
    };

    port = lib.mkOption {
      default = [ 3128 ];
      type = lib.types.listOf lib.types.port;
      description = "Specifies on which ports the cntlm daemon listens.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Additional config appended to the end of the generated {file}`cntlm.conf`.";
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to custom {file}`cntlm.conf`.
        If unset, the config file will be generated based on the value of other options.
      '';
    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {
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

    users.users.cntlm = {
      name = "cntlm";
      description = "cntlm system-wide daemon";
      isSystemUser = true;
    };
  };
}
