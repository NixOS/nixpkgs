{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption types;
  inherit (types)
    port
    str
    ;
in
{
  imports = [
    ./common-options.nix
  ];

  options = {
    enable = mkEnableOption "Bore TCP tunnel (remote proxy server) for `<name>`";

    min-port = mkOption {
      type = port;
      default = 1024;
      description = ''
        Minimum accepted TCP port number.
      '';
    };

    max-port = mkOption {
      type = port;
      default = 65535;
      description = ''
        Maximum accepted TCP port number.
      '';
    };

    bind-addr = mkOption {
      type = str;
      default = "0.0.0.0";
      description = ''
        IP address to bind to, clients must reach this.
      '';
    };

    bind-tunnels = mkOption {
      type = str;
      default = config.bind-addr;
      defaultText = lib.literalExpression "config.${options.bind-addr}";
      description = ''
        IP address where tunnels will listen on.
      '';
    };
  };
}
