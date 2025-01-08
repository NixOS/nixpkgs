{ cfg }:
{
  config,
  lib,
  name,
  ...
}:

{
  options = {

    hostName = lib.mkOption {
      type = lib.types.str;
      default = name;
      description = "Canonical hostname for the server.";
    };

    serverAliases = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = [
        "www.example.org"
        "example.org"
      ];
      description = ''
        Additional names of virtual hosts served by this virtual host configuration.
      '';
    };

    listenAddresses = lib.mkOption {
      type = with lib.types; listOf str;
      description = ''
        A list of host interfaces to bind to for this virtual host.
      '';
      default = [ ];
      example = [
        "127.0.0.1"
        "::1"
      ];
    };

    useACMEHost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        A host of an existing Let's Encrypt certificate to use.
        This is mostly useful if you use DNS challenges but Caddy does not
        currently support your provider.

        *Note that this option does not create any certificates, nor
        does it add subdomains to existing ones – you will need to create them
        manually using [](#opt-security.acme.certs).*
      '';
    };

    logFormat = lib.mkOption {
      type = lib.types.lines;
      default = ''
        output file ${cfg.logDir}/access-${config.hostName}.log
      '';
      defaultText = ''
        output file ''${config.services.caddy.logDir}/access-''${hostName}.log
      '';
      example = lib.literalExpression ''
        mkForce '''
          output discard
        ''';
      '';
      description = ''
        Configuration for HTTP request logging (also known as access logs). See
        <https://caddyserver.com/docs/caddyfile/directives/log#log>
        for details.
      '';
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Additional lines of configuration appended to this virtual host in the
        automatically generated `Caddyfile`.
      '';
    };

  };
}
