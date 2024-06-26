{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  inherit (lib) literalExpression mkOption types;
  cfg = config.security.dhparams;
  opt = options.security.dhparams;

  bitType = types.addCheck types.int (b: b >= 16) // {
    name = "bits";
    description = "integer of at least 16 bits";
  };

  paramsSubmodule =
    { name, config, ... }:
    {
      options.bits = mkOption {
        type = bitType;
        default = cfg.defaultBitSize;
        defaultText = literalExpression "config.${opt.defaultBitSize}";
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
          {option}`security.dhparams.path`.
        '';
      };

      config.path =
        let
          generated = pkgs.runCommand "dhparams-${name}.pem" {
            nativeBuildInputs = [ pkgs.openssl ];
          } "openssl dhparam -out \"$out\" ${toString config.bits}";
        in
        if cfg.stateful then "${cfg.path}/${name}.pem" else generated;
    };

in
{
  options = {
    security.dhparams = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to generate new DH params and clean up old DH params.
        '';
      };

      params = mkOption {
        type =
          with types;
          let
            coerce = bits: { inherit bits; };
          in
          attrsOf (coercedTo int coerce (submodule paramsSubmodule));
        default = { };
        example = lib.literalExpression "{ nginx.bits = 3072; }";
        description = ''
          Diffie-Hellman parameters to generate.

          The value is the size (in bits) of the DH params to generate. The
          generated DH params path can be found in
          `config.security.dhparams.params.«name».path`.

          ::: {.note}
          The name of the DH params is taken as being the name of
          the service it serves and the params will be generated before the
          said service is started.
          :::

          ::: {.warning}
          If you are removing all dhparams from this list, you
          have to leave {option}`security.dhparams.enable` for at
          least one activation in order to have them be cleaned up. This also
          means if you rollback to a version without any dhparams the
          existing ones won't be cleaned up. Of course this only applies if
          {option}`security.dhparams.stateful` is
          `true`.
          :::

          ::: {.note}
          **For module implementers:** It's recommended
          to not set a specific bit size here, so that users can easily
          override this by setting
          {option}`security.dhparams.defaultBitSize`.
          :::
        '';
      };

      stateful = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether generation of Diffie-Hellman parameters should be stateful or
          not. If this is enabled, PEM-encoded files for Diffie-Hellman
          parameters are placed in the directory specified by
          {option}`security.dhparams.path`. Otherwise the files are
          created within the Nix store.

          ::: {.note}
          If this is `false` the resulting store
          path will be non-deterministic and will be rebuilt every time the
          `openssl` package changes.
          :::
        '';
      };

      defaultBitSize = mkOption {
        type = bitType;
        default = 2048;
        description = ''
          This allows to override the default bit size for all of the
          Diffie-Hellman parameters set in
          {option}`security.dhparams.params`.
        '';
      };

      path = mkOption {
        type = types.str;
        default = "/var/lib/dhparams";
        description = ''
          Path to the directory in which Diffie-Hellman parameters will be
          stored. This only is relevant if
          {option}`security.dhparams.stateful` is
          `true`.
        '';
      };
    };
  };

  config = lib.mkIf (cfg.enable && cfg.stateful) {
    systemd.services =
      {
        dhparams-init = {
          description = "Clean Up Old Diffie-Hellman Parameters";

          # Clean up even when no DH params is set
          wantedBy = [ "multi-user.target" ];

          serviceConfig.RemainAfterExit = true;
          serviceConfig.Type = "oneshot";

          script = ''
            if [ ! -d ${cfg.path} ]; then
              mkdir -p ${cfg.path}
            fi

            # Remove old dhparams
            for file in ${cfg.path}/*; do
              if [ ! -f "$file" ]; then
                continue
              fi
              ${
                lib.concatStrings (
                  lib.mapAttrsToList (
                    name:
                    { bits, path, ... }:
                    ''
                      if [ "$file" = ${lib.escapeShellArg path} ] && \
                         ${pkgs.openssl}/bin/openssl dhparam -in "$file" -text \
                         | head -n 1 | grep "(${toString bits} bit)" > /dev/null; then
                        continue
                      fi
                    ''
                  ) cfg.params
                )
              }
              rm $file
            done

            # TODO: Ideally this would be removing the *former* cfg.path, though
            # this does not seem really important as changes to it are quite
            # unlikely
            rmdir --ignore-fail-on-non-empty ${cfg.path}
          '';
        };
      }
      // lib.mapAttrs' (
        name:
        { bits, path, ... }:
        lib.nameValuePair "dhparams-gen-${name}" {
          description = "Generate Diffie-Hellman Parameters for ${name}";
          after = [ "dhparams-init.service" ];
          before = [ "${name}.service" ];
          wantedBy = [ "multi-user.target" ];
          unitConfig.ConditionPathExists = "!${path}";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir -p ${lib.escapeShellArg cfg.path}
            ${pkgs.openssl}/bin/openssl dhparam -out ${lib.escapeShellArg path} \
              ${toString bits}
          '';
        }
      ) cfg.params;
  };

  meta.maintainers = with lib.maintainers; [ ekleog ];
}
