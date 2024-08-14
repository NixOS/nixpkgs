{ lib
, pkgs
, config
, ...
}:
let
  inherit (lib)
    concatStringsSep
    filterAttrs
    isPath
    mapAttrs'
    mkOption
    types
    ;
  top = config.security.certificates;
in
{
  options = {
    security.certificates.authorities.vault.settings = mkOption {
      type = types.submodule {
        options = {
          # TODO: Support more authentication types other then a static token
          # file
          token = mkOption {
            type = types.path;
            description = "Token file to authenticate to Vault with";
          };
          URI = {
            protocol = mkOption {
              type = types.enum [
                "unix"
                "http"
                "https"
              ];
              description = ''
                Protocol to use when connecting to Vault.
              '';
              default = "http";
            };
            address = mkOption {
              type = types.str;
              description = ''
                Hostname, IP address, or socket path Vault server is listening
                on.
              '';
              default = "127.0.0.1";
            };
            port = mkOption {
              type = types.port;
              description = ''
                Port vault server is listening on, not used when
                protocol = `unix`.
              '';
              default = 8200;
            };
          };
          role = mkOption {
            type = types.str;
            description = ''
              Role to request certificates from
            '';
          };
        };
      };
      description = ''
        Per certificate options specific to the "vault" authority.
      '';
      default = { };
    };
  };
  # TODO: Certificate renewal
  # TODO: Support more certificate spec options
  config =
    let
      specs = filterAttrs (_: spec: spec.authority ? vault) top.specifications;
    in
    {
      systemd.services = mapAttrs'
        (
          name:
          { output
          , authority
          , service
          , ...
          }:
          let
            inherit (authority) vault;
            inherit (output) scripts;
            token = "$(cat ${vault.token})";
            # `authority.vault` is a attrTag and *should* only have one child
            # attr which *should* be convertible to a string
            addr =
              let
                inherit (vault.URI) protocol address port;
              in
              if (protocol == "unix") then
                (
                  if (isPath address) then
                    "--unix-socket ${address} http://unix"
                  else
                    abort "Vault protocol is unix but address ${address} is not a valid path"
                )
              else
                "${protocol}://${address}:${toString port}";
            endpoint = "${addr}/v1/pki/sign/${vault.role}";
            curlFlags = concatStringsSep " " [
              "--silent"
              "--show-error"
              "--header"
              "X-Vault-Token:${token}"
              "--request"
              "POST"
            ];
          in
          {
            name = service;
            value = {
              path = with pkgs; [
                curl
                coreutils
                jq
              ];
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = "true";
                RuntimeDirectory = "certificate/${name}";
                WorkingDirectory = "%t/certificate/${name}";
                ExecStartPost = [ "+${scripts.doInstall} ./key.pem ./crt.pem ./ca.pem" ];
              };
              script = ''
                KEY=./key.pem
                CSR=./csr.pem
                ${scripts.mkKey} > $KEY
                ${scripts.mkCSR} < $KEY > $CSR
                DATA=$(jq -n -c --rawfile CSR $CSR '{"csr":$CSR}')
                curl --data "$DATA" ${curlFlags} ${endpoint} > cert.json
                if jq -e 'has("errors")' < cert.json > /dev/null; then
                  echo '<3>Certificate request failed with:'
                  jq -r '.errors | map("<3>  " + .)[]' < cert.json
                  exit 1
                fi
                if jq -e 'has("warnings")' < cert.json > /dev/null; then
                  echo '<4>Certificate created with warnings:'
                  jq -r '.warnings | map("<4>  " + .)[]' < cert.json
                fi
                jq -r .data.certificate < cert.json > crt.pem
                jq -r .data.issuing_ca < cert.json > ca.pem
              '';
            };
          }
        )
        specs;
    };
  imports = [ ./server.nix ];
}
