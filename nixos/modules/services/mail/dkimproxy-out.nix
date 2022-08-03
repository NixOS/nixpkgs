{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.dkimproxy-out;
  keydir = "/var/lib/dkimproxy-out";
  privkey = "${keydir}/private.key";
  pubkey = "${keydir}/public.key";
in
{
  ##### interface
  options = {
    services.dkimproxy-out = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description =
          lib.mdDoc ''
            Whether to enable dkimproxy_out.

            Note that a key will be auto-generated, and can be found in
            ${keydir}.
          '';
      };

      listen = mkOption {
        type = types.str;
        example = "127.0.0.1:10027";
        description = lib.mdDoc "Address:port DKIMproxy should listen on.";
      };

      relay = mkOption {
        type = types.str;
        example = "127.0.0.1:10028";
        description = lib.mdDoc "Address:port DKIMproxy should forward mail to.";
      };

      domains = mkOption {
        type = with types; listOf str;
        example = [ "example.org" "example.com" ];
        description = lib.mdDoc "List of domains DKIMproxy can sign for.";
      };

      selector = mkOption {
        type = types.str;
        example = "selector1";
        description =
          ''
            The selector to use for DKIM key identification.

            For example, if 'selector1' is used here, then for each domain
            'example.org' given in `domain`, 'selector1._domainkey.example.org'
            should contain the TXT record indicating the public key is the one
            in ${pubkey}: "v=DKIM1; t=s; p=[THE PUBLIC KEY]".
          '';
      };

      keySize = mkOption {
        type = types.int;
        default = 2048;
        description =
          lib.mdDoc ''
            Size of the RSA key to use to sign outgoing emails. Note that the
            maximum mandatorily verified as per RFC6376 is 2048.
          '';
      };

      # TODO: allow signature for other schemes than dkim(c=relaxed/relaxed)?
      # This being the scheme used by gmail, maybe nothing more is needed for
      # reasonable use.
    };
  };

  ##### implementation
  config = let
    configfile = pkgs.writeText "dkimproxy_out.conf"
      ''
        listen ${cfg.listen}
        relay ${cfg.relay}

        domain ${concatStringsSep "," cfg.domains}
        selector ${cfg.selector}

        signature dkim(c=relaxed/relaxed)

        keyfile ${privkey}
      '';
  in
    mkIf cfg.enable {
      users.groups.dkimproxy-out = {};
      users.users.dkimproxy-out = {
        description = "DKIMproxy_out daemon";
        group = "dkimproxy-out";
        isSystemUser = true;
      };

      systemd.services.dkimproxy-out = {
        description = "DKIMproxy_out";
        wantedBy = [ "multi-user.target" ];
        preStart = ''
          if [ ! -d "${keydir}" ]; then
            mkdir -p "${keydir}"
            chmod 0700 "${keydir}"
            ${pkgs.openssl}/bin/openssl genrsa -out "${privkey}" ${toString cfg.keySize}
            ${pkgs.openssl}/bin/openssl rsa -in "${privkey}" -pubout -out "${pubkey}"
            chown -R dkimproxy-out:dkimproxy-out "${keydir}"
          fi
        '';
        script = ''
          exec ${pkgs.dkimproxy}/bin/dkimproxy.out --conf_file=${configfile}
        '';
        serviceConfig = {
          User = "dkimproxy-out";
          PermissionsStartOnly = true;
        };
      };
    };

  meta.maintainers = with lib.maintainers; [ ekleog ];
}
