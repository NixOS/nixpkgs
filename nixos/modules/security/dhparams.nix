{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.security.dhparams;
in
{
  options = {
    security.dhparams = {
      params = mkOption {
        description =
          ''
            Diffie-Hellman parameters to generate.

            The value is the size (in bits) of the DH params to generate. The
            generated DH params path can be found in
            <filename><replaceable>security.dhparams.path</replaceable>/<replaceable>name</replaceable>.pem</filename>.

            Note: The name of the DH params is taken as being the name of the
            service it serves: the params will be generated before the said
            service is started.
          '';
        type = with types; attrsOf int;
        default = {};
        example = { nginx = 3072; };
      };

      path = mkOption {
        description =
          ''
            Path to the directory in which Diffie-Hellman parameters will be
            stored.
          '';
        type = types.str;
        default = "/var/lib/dhparams";
      };
    };
  };

  config.systemd.services = {
    dhparams-init = {
      description = "Cleanup old Diffie-Hellman parameters";
      wantedBy = [ "multi-user.target" ]; # Clean up even when no DH params is set
      serviceConfig.Type = "oneshot";
      script =
        # Create directory
        ''
          if [ ! -d ${cfg.path} ]; then
            mkdir -p ${cfg.path}
          fi
        '' +
        # Remove old dhparams
        ''
          for file in ${cfg.path}/*; do
            if [ ! -f "$file" ]; then
              continue
            fi
        '' + concatStrings (mapAttrsToList (name: value:
        ''
            if [ "$file" == "${cfg.path}/${name}.pem" ] && \
                ${pkgs.openssl}/bin/openssl dhparam -in "$file" -text | head -n 1 | grep "(${toString value} bit)" > /dev/null; then
              continue
            fi
        ''
        ) cfg.params) +
        ''
            rm $file
          done

          # TODO: Ideally this would be removing the *former* cfg.path, though this
          # does not seem really important
          rmdir -p --ignore-fail-on-non-empty ${cfg.path}
        '';
    };
  } //
    mapAttrs' (name: value: nameValuePair "dhparams-gen-${name}" {
      description = "Generate Diffie-Hellman parameters for ${name} if they don't exist yet";
      after = [ "dhparams-init.service" ];
      before = [ "${name}.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script =
        ''
          mkdir -p ${cfg.path}
          if [ ! -f ${cfg.path}/${name}.pem ]; then
            ${pkgs.openssl}/bin/openssl dhparam -out ${cfg.path}/${name}.pem ${toString value}
          fi
        '';
    }) cfg.params;
}
