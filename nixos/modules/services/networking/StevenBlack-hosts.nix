{config, lib, pkgs, ...}:
with lib;
{
  options.services.stevenBlackHosts = {
    enable = mkEnableOption "filtering hosts via StevenBlack's hosts file";
    flags = mkOption {
      description = ''
        Flags to passs while building the hosts file.
        Note that compress and skipstatichosts are passed by default.
        See also <link xlink:href="https://github.com/StevenBlack/hosts#command-line-options>here</link> for details.
        Note that options that modify directly the hosts file or he global DNS cache will error out
        as the host file is first built in the standard nix sandbox.
      '';
      default = {};
      #TODO: cli setting type
      type = with types; attrsOf (
        oneOf [bool str (listOf bool) (listOf str)]
      );

    };
    whitelist = mkOption {
      description = "List of hosts to allow,one host per line.";
      default = "";
      type = types.lines;

    };
  };

  config =
    let
      cfg = config.services.stevenBlackHosts;
    in mkIf cfg.enable {

      services.stevenBlackHosts.flags={
        compress = mkDefault true;
        skipstatichosts = mkDefault true;
      };

      networking.hostFiles = let
        hosts = pkgs.StevenBlack-hosts.override {
          inherit (cfg) flags whitelist;
        };
      in [( "${hosts}/share/StevenBlack-hosts/hosts" )];
    };
}
