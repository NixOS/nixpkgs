{ config, pkgs, lib, ... }:

with lib;
let
  formatConsulParams = attrs: (concatStringsSep " " (
    flip mapAttrsToList attrs (key: value: ("\"${key}=${value}\""))
  ));

  backendToDefName = backend: if (backend == "kv") then "secret" else backend;

  createConsulTemplates = key:
    let
      # figure out what backend we're going to use
      backendFilter = filterAttrs (n: v: v != null) key.backends;
      backendCount = length (attrNames backendFilter);
      backendName = if (backendCount > 0) then (head (attrNames backendFilter)) else null;
      backend = if (backendCount > 0) then (head (attrValues backendFilter)) else null;

      type = backendName;
      name = if (key.backendName != null) then key.backendName else backendToDefName backendName;

      # info shared between all templates
      keyInfo =
        if type == "kv" then {
          addr = "${name}/data/${backend.path}";
          params = { };
        } else if type == "pki" then {
          addr = "${name}/issue/${backend.policy}";
          params = { "common_name" = backend.commonName; };
        } else null;

      # template outputs for each type
      keyTmpls =
        if key.template != null then [{
          body = key.template;
        }] else if type == "kv" then [{
          body = [ "{{ .Data.data | toJSON }}" ];
        }] else if type == "pki" then
          (
            let
              # repr of the certificate
              certLines = [
                "{{- .Data.certificate }}"
              ] ++ (optional backend.fullChain [
                "{{- if index .Data \"ca_chain\" }}"
                "{{- range $cert := .Data.ca_chain }}\n{{ $cert }}{{ end }}"
                "{{- end }}"
              ]);

              # repr of the private key
              keyLines = [
                "{{- .Data.private_key }}"
              ];
            in
            # whether to split or bundle them together
            if backend.bundle then [{
              body = certLines ++ [ "" ] ++ keyLines;
            }] else [
              {
                suffix = "public";
                body = certLines;
              }
              {
                suffix = "private";
                body = keyLines;
              }]
          ) else null;

      # final template generator
    in
    assert (assertMsg (backendCount == 1)) "vault key ${key.name}: exactly one backend must be specified";

    forEach keyTmpls (template: rec {
      suffix = if template ? suffix then template.suffix else null;
      id = if (suffix != null) then "${key.name}-${template.suffix}" else key.name;

      text = concatStringsSep "\n" (flatten [
        "{{- with secret \"${keyInfo.addr}\" ${formatConsulParams keyInfo.params} }}"
        template.body
        "{{- end }}"
      ]);
    });

  backendTypes = {
    kv = types.submodule ({ config, ... }: {
      options = {
        path = mkOption {
          default = null;
          type = types.nullOr types.str;
          description = "Path to the key/value key in Vault.";
        };

        field = mkOption {
          default = null;
          type = types.nullOr types.str;
          description = "Default key/value field to use.";
        };
      };
    });

    pki = types.submodule ({ config, ... }: {
      options = {
        policy = mkOption {
          type = types.str;
          description = "Name of the PKI policy in Vault.";
        };

        bundle = mkOption {
          default = false;
          type = types.bool;
          description = "Whether to bundle both the certificate and private key into one file.";
        };

        commonName = mkOption {
          type = types.str;
          description = "Common name of the certificate.";
        };

        fullChain = mkOption {
          default = true;
          type = types.bool;
          description = "Includes the full certificate chain.";
        };
      };
    });
  };

  sinkType = types.submodule ({ config, name, ... }: {
    options = {
      name = mkOption {
        default = name;
        type = types.str;
        description = "Name of the destination file. Default is to use the sink name.";
      };

      user = mkOption {
        default = "root";
        type = types.str;
        description = "The user which will be the owner of the key file.";
      };

      group = mkOption {
        default = "root";
        type = types.str;
        description = "The group that will be set for the key file.";
      };

      permissions = mkOption {
        default = "0600";
        example = "0640";
        type = types.str;
        description = ''
          The default permissions to set for the key file, needs to be in the
          format accepted by ``chmod(1)``.
        '';
      };

      kv = {
        field = mkOption {
          default = null;
          type = types.nullOr types.str;
          description = "The key/value field that this sink should pull from.";
        };
      };
    };
  });

  keyType = types.submodule ({ config, name, ... }: {
    options = {
      name = mkOption {
        example = "secret-123";
        default = name;
        type = types.str;
        description = "The name of the key.";
      };

      folder = mkOption {
        default = "/run/vault-keys";
        type = types.str;
        description = "The location to render the key to.";
      };

      template = mkOption {
        default = null;
        type = types.nullOr types.lines;
        description = "Specifies a custom HCL template to render the key. Overrides built-in sink renderers.";
      };

      backends = {
        kv = mkOption {
          default = null;
          type = types.nullOr backendTypes.kv;
          description = "Configuration for the KeyValues backend.";
        };

        pki = mkOption {
          default = null;
          type = types.nullOr backendTypes.pki;
          description = "Configuration for the PKI backend.";
        };
      };

      backendName = mkOption {
        default = null;
        example = "pki_int";
        type = types.nullOr types.str;
        description = "The name of the Vault backend. Default is to use the default name for the backend type.";
      };

      # TODO: We need to get vault-agent to reload whenever this changes, how?
      sinks = mkOption {
        default = { "${name}" = { }; };
        type = types.attrsOf sinkType;
        description = "List of sink configurations that describe how to render this key to a file. If not set, the key name will be used.";
      };

      postRenew = {
        command = mkOption {
          default = "";
          type = types.str;
          description = "Optional command to run after the key is renewed.";
        };

        restart = mkOption {
          default = false;
          type = types.bool;
          description = "Whether to automatically restart or reload systemd units when the key is renewed.";
        };
      };

      dependency = {
        units = mkOption {
          default = [ ];
          example = "[ \"nginx\" ]";
          type = types.listOf types.str;
          description = "Dependent systemd units for the key.";
        };
      };

      external = mkOption {
        default = false;
        type = types.bool;
        description = "Specifies that this key will be pushed externally by a tool rather than being pulled by the host's agent.";
      };
    };
  });

  # build all the vault agent templates for a key
  buildAgentTemplates = key:
    let
      defaults = {
        createDestDirs = false;
        sandboxPath = key.folder;
      };
    in
    (forEach key.templates (template: ({
      sourceFile = pkgs.writeText "vault-key-${template.id}.ctmpl" template.text;
      destFile = "${key.folder}/.${template.id}.tmp";
    } // defaults)));

  # builds the final set of keys
  finalKeys = (flip mapAttrs config.security.vault-keys (_: key: key // { templates = createConsulTemplates key; }));
in
{
  options = {
    security.vault-keys = mkOption {
      default = { };
      type = types.attrsOf keyType;
      description = "Attributes of vault keys to deploy.";
    };

    reflection.vault-keys = mkOption {
      default = finalKeys;
      type = types.attrs;
      description = "Allows extration of template values by an external script.";
    };
  };

  config = mkIf (length (attrNames config.security.vault-keys) > 0) {
    services.vault-agent.templates =
      let
        # exclude keys marked as external as they do not use the agent
        keys = filterAttrs (k: v: v.external == false) finalKeys;
      in
      flatten (flip mapAttrsToList keys (_: key: buildAgentTemplates key));

    users.users = (listToAttrs (flatten (flip mapAttrsToList finalKeys (_: key:
      (flip mapAttrsToList (flip filterAttrs key.sinks (_: sink: sink.user != "root")) (_: sink: (nameValuePair sink.user { extraGroups = [ "keys" ]; })))
    ))));

    systemd.services = # create a service for every key
      (listToAttrs (flip mapAttrsToList finalKeys (_: key: {
        name = "vault-key-${key.name}";
        value =
          let
            # the default template
            default = head key.templates;

            keyRenderWait = pkgs.writeScriptBin "key-render-wait" (builtins.readFile ./key-render-wait.py);

            # filenames for the temporary files and target sink files
            tempFileNames = concatStringsSep "," (map (template: ".${template.id}.tmp") key.templates);
            sinkFileNames = concatStringsSep "," (flatten (flip mapAttrsToList key.sinks (_: sink:
              if (key.template == null && ((length key.templates) > 1)) then (map (t: "${sink.name}-${t.suffix}") key.templates) else sink.name
            )));
          in
          {
            description = "Vault key activation service";

            before = key.dependency.units;
            after = [ "vault-agent.target" ];
            wants = [ "vault-agent.target" ];
            wantedBy = [ "multi-user.target" ] ++ key.dependency.units;

            path = with pkgs; [
              (python3.withPackages (p: with p; [
                inotify-simple
              ]))
            ];

            serviceConfig = {
              Restart = "always";
              RestartSec = "100ms";
              TimeoutStartSec = "infinity";
            };

            preStart = ''
              # Wait for create/move if any keys don't exist here
              ${keyRenderWait}/bin/key-render-wait -t "${tempFileNames}" -s "${sinkFileNames}" -d "${key.folder}"
            '';

            script = ''
              set -euo pipefail

              # if the key's folder does not exist, create it
              if [[ ! -d "${key.folder}" ]]; then
                  mkdir -p "${key.folder}"
                  chmod -R 0600 "${key.folder}"
              fi

              # we are now DONE waiting for all the keys
              # finally render them
            ${concatStringsSep "\n" (flatten ([
              (flip mapAttrsToList key.sinks (_: sink:
              let
              buildKey = render: dest: id:
              let
                  tempFile = "${key.folder}/.${id}.tmp";
              in
              # if the temp file doesn't exist, don't attempt to render and instead use the old version
              ''
                if [[ -f "${tempFile}" ]]; then
                    rm -rf "${dest}"
                    ${render}
                    chmod ${sink.permissions} "${dest}"
                    chown "${sink.user}:${sink.group}" "${dest}"
                fi
              '';

              buildStandaloneKey =
              let
                  dest = "${key.folder}/${sink.name}";
              in
              buildKey ''cp "${key.folder}/.${default.id}.tmp" "${dest}"'' dest default.id;
              in
              # we're always standalone if the parent key is overriding with a custom template
              if key.template != null then buildStandaloneKey

              # composite keys (suffixed with template suffix)
              else if (length key.templates) > 1 then
              (forEach key.templates (template:
              let
                  dest = "${key.folder}/${sink.name}-${template.suffix}";
              in
              buildKey ''cp "${key.folder}/.${template.id}.tmp" "${dest}"'' dest template.id))

              # special for key/value keys (file per field)
              else if (key.backends.kv != null) then
              let
                  dest = "${key.folder}/${sink.name}";
              in
                  buildKey ''cat "${key.folder}/.${default.id}.tmp" | ${pkgs.jq}/bin/jq -j -r '.["${sink.kv.field}"]' > "${dest}"'' dest default.id

                  # fallback to regular
                  else buildStandaloneKey))

                  # remove the temporary files, but not for external keys as we might need to re-render them
                  # TODO: could we actually just do this for all keys, i.e. not remove the tempfiles?
                  (optional (key.external == false) (forEach key.templates (template: ''rm -f "${key.folder}/.${template.id}.tmp"'')))
              ]))}

              # perform actions on dependent units
              ${concatStrings (if key.postRenew.restart then
              (forEach key.dependency.units (unit: (
              ''
                systemctl reload-or-restart ${unit} --no-block
              ''
              ))) else [ ])}

              ${key.postRenew.command}

              # Wait for key modification and exit if so
              ${keyRenderWait}/bin/key-render-wait -m -t "${tempFileNames}" -d "${key.folder}"
            '';
          };
      }))) //

      # default systemd options
      {
        vault-agent.serviceConfig.ReadWritePaths = "/run/vault-keys";
      };

    system.activationScripts.vault-keys =
      let script = ''
        mkdir -p /run/vault-keys -m 0770
        chown root:keys /run/vault-keys
      '';
      in stringAfter [ "users" "groups" ] "source ${pkgs.writeText "setup-vault-keys.sh" script}";
  };
}
