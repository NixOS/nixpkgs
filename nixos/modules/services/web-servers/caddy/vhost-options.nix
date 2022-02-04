{ cfg }:
{ config, lib, name, ... }:
let
  inherit (lib) literalExpression mkOption types;
in
{
  options = {

    hostName = mkOption {
      type = types.str;
      default = name;
      description = "Canonical hostname for the server.";
    };

    serverAliases = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [ "www.example.org" "example.org" ];
      description = ''
        Additional names of virtual hosts served by this virtual host configuration.
      '';
    };

    listenAddresses = mkOption {
      type = with types; listOf str;
      description = ''
        A list of host interfaces to bind to for this virtual host.
      '';
      default = [ ];
      example = [ "127.0.0.1" "::1" ];
    };

    useACMEHost = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        A host of an existing Let's Encrypt certificate to use.
        This is mostly useful if you use DNS challenges but Caddy does not
        currently support your provider.

        <emphasis>Note that this option does not create any certificates, nor
        does it add subdomains to existing ones – you will need to create them
        manually using <xref linkend="opt-security.acme.certs"/>. Additionally,
        you should probably add the <literal>caddy</literal> user to the
        <literal>acme</literal> group to grant access to the certificates.</emphasis>
      '';
    };

    logFormat = mkOption {
      type = types.lines;
      default = ''
        output file ${cfg.logDir}/access-${config.hostName}.log
      '';
      defaultText = ''
        output file ''${config.services.caddy.logDir}/access-''${hostName}.log
      '';
      example = literalExpression ''
        mkForce '''
          output discard
        ''';
      '';
      description = ''
        Configuration for HTTP request logging (also known as access logs). See
        <link xlink:href="https://caddyserver.com/docs/caddyfile/directives/log#log"/>
        for details.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional lines of configuration appended to this virtual host in the
        automatically generated <literal>Caddyfile</literal>.
      '';
    };

  };
}
