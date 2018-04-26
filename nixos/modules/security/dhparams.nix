{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.dhparams;

  paramsSubmodule = { name, config, ... }: {
    options.bits = mkOption {
      type = types.addCheck types.int (b: b >= 16) // {
        name = "bits";
        description = "integer of at least 16 bits";
      };
      default = 4096;
      description = ''
        The bit size for the prime that is used during a Diffie-Hellman
        key exchange.
      '';
    };

    options.path = mkOption {
      type = types.path;
      readOnly = true;
      description = ''
        The resulting path of the generated Diffie-Hellman parameters
        file for other services to reference. This could be either a
        store path or a file inside the directory specified by
        <option>security.dhparams.path</option>.
      '';
    };

    config.path = let
      generated = pkgs.runCommand "dhparams-${name}.pem" {
        nativeBuildInputs = [ pkgs.openssl ];
      } "openssl dhparam -out \"$out\" ${toString config.bits}";
    in if cfg.stateful then "${cfg.path}/${name}.pem" else generated;
  };

in {
  options = {
    security.dhparams = {
      params = mkOption {
        description =
          ''
            Diffie-Hellman parameters to generate.

            The value is the size (in bits) of the DH params to generate. The
            generated DH params path can be found in
            <literal>config.security.dhparams.params.<replaceable>name</replaceable>.path</literal>.

            <note><para>The name of the DH params is taken as being the name of
            the service it serves and the params will be generated before the
            said service is started.</para></note>

            <warning><para>If you are removing all dhparams from this list, you
            have to leave <option>security.dhparams.enable</option> for at
            least one activation in order to have them be cleaned up. This also
            means if you rollback to a version without any dhparams the
            existing ones won't be cleaned up. Of course this only applies if
            <option>security.dhparams.stateful</option> is
            <literal>true</literal>.</para></warning>
          '';
        type = with types; let
          coerce = bits: { inherit bits; };
        in attrsOf (coercedTo types.int coerce (submodule paramsSubmodule));
        default = {};
        example = literalExample "{ nginx.bits = 3072; }";
      };

      stateful = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether generation of Diffie-Hellman parameters should be stateful or
          not. If this is enabled, PEM-encoded files for Diffie-Hellman
          parameters are placed in the directory specified by
          <option>security.dhparams.path</option>. Otherwise the files are
          created within the Nix store.

          <note><para>If this is <literal>false</literal> the resulting store
          path will be non-deterministic and will be rebuilt every time the
          <package>openssl</package> package changes.</para></note>
        '';
      };

      path = mkOption {
        description = ''
          Path to the directory in which Diffie-Hellman parameters will be
          stored. This only is relevant if
          <option>security.dhparams.stateful</option> is
          <literal>true</literal>.
        '';
        type = types.str;
        default = "/var/lib/dhparams";
      };

      enable = mkOption {
        description =
          ''
            Whether to generate new DH params and clean up old DH params.
          '';
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf (cfg.enable && cfg.stateful) {
    systemd.services = {
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
          '' + concatStrings (mapAttrsToList (name: { bits, ... }:
          ''
              if [ "$file" == "${cfg.path}/${name}.pem" ] && \
                  ${pkgs.openssl}/bin/openssl dhparam -in "$file" -text | head -n 1 | grep "(${toString bits} bit)" > /dev/null; then
                continue
              fi
          ''
          ) cfg.params) +
          ''
              rm $file
            done

            # TODO: Ideally this would be removing the *former* cfg.path, though this
            # does not seem really important as changes to it are quite unlikely
            rmdir --ignore-fail-on-non-empty ${cfg.path}
          '';
      };
    } //
      mapAttrs' (name: { bits, ... }: nameValuePair "dhparams-gen-${name}" {
        description = "Generate Diffie-Hellman parameters for ${name} if they don't exist yet";
        after = [ "dhparams-init.service" ];
        before = [ "${name}.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";
        script =
          ''
            mkdir -p ${cfg.path}
            if [ ! -f ${cfg.path}/${name}.pem ]; then
              ${pkgs.openssl}/bin/openssl dhparam -out ${cfg.path}/${name}.pem ${toString bits}
            fi
          '';
      }) cfg.params;
  };
}
