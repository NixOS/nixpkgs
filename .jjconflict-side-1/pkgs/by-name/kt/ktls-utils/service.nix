# Non-module dependencies (`importApply`)
{ }:

# Service module
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib)
    getExe
    mkOption
    types
    ;
  cfg = config.tlshd;

  configFile = config.configData."tlshd.conf".path;
in
{
  # https://nixos.org/manual/nixos/unstable/#modular-services
  _class = "service";

  options.tlshd = {
    package = mkOption {
      description = "Package to use for tlshd.";
      defaultText = lib.literalMD "The `ktls-utils` package that provided this module.";
      type = types.package;
    };

    settings = mkOption {
      description = ''
        Configuration for tlshd in INI format.
        See {manpage}`tlshd.conf(5)` for available options.
      '';
      type = types.attrsOf (types.attrsOf types.str);
      default = { };
      example = lib.literalExpression ''
        {
          "authenticate.server" = {
            "x509.certificate" = "/var/lib/tlshd/cert.pem";
            "x509.private_key" = "/var/lib/tlshd/key.pem";
            "x509.truststore" = "/var/lib/tlshd/truststore.pem";
          };
        }
      '';
    };
  };

  config = {
    configData."tlshd.conf".text = lib.generators.toINI { } cfg.settings;

    process.argv = [
      (getExe cfg.package)
      "--config"
      configFile
    ];
  }
  // lib.optionalAttrs (options ? systemd) {
    systemd.service = {
      description = "Handshake service for kernel TLS consumers";
      documentation = [ "man:tlshd(8)" ];
      unitConfig.DefaultDependencies = false;
      before = [ "remote-fs-pre.target" ];
      wantedBy = [ "remote-fs.target" ];
      serviceConfig = {
        Restart = "on-failure";
        DynamicUser = true;
        AmbientCapabilities = [ "CAP_NET_ADMIN" ];
        CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
      };
    };
  };
}
