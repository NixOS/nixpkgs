{ lib, pkgs, config, ... }:
let
  inherit (lib)
    concatLines
    concatStringsSep
    escapeShellArg
    filterAttrs
    getAttrs
    mapAttrs'
    mapAttrsToList
    mkOption
    types;
  top = config.security.certificates;
in
{
  options = with types; {
    security.certificates.authorities.vault.settings = mkOption
      {
        type = submodule {
          options = {
            # TODO: Support more authentication types other then a static token
            # file
            token = mkOption {
              type = path;
              description = "Token file to authenticate to Vault with";
            };
            vault = {
              protocol = mkOption {
                type = enum [
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
                type = str;
                description = ''
                  Hostname, IP address, or socket path Vault server is listening
                  on.
                '';
                default = "127.0.0.1";
              };
              port = mkOption {
                type = port;
                description = ''
                  Port vault server is listening on, not used when 
                  protocol = `unix`.
                '';
                default = 8200;
              };
            };
            role = mkOption {
              type = str;
              description = ''
                Role to request certificates from
              '';
            };
          };
        };
        default = { };
      };
  };
  # TODO: Certificate renewal
  # TODO: Support more certificate spec options
  config =
    let
      specs = filterAttrs
        (_: spec: spec.authority ? vault)
        top.specifications;
    in
    {
      systemd.services = mapAttrs'
        (name: spec:
          let
            inherit (spec.request) CN;
            authority = spec.authority.vault;
            commas = concatStringsSep ",";
            # Helper to create an appropriate install line
            install =
              src:
              { path
              , owner ? "$(id -u)"
              , group ? "$(id -g)"
              , mode ? "0600"
              }:
              "install"
              + " -Dv -o ${owner} -g ${group} -m ${mode}"
              + " ${escapeShellArg src} ${escapeShellArg path}";
            token = "$(cat ${authority.token})";
            # `authority.vault` is a attrTag and *should* only have one child
            # attr which *should* be convertible to a string
            addr = with authority.vault;
              if (protocol == "unix")
              then
                (
                  if (isPath address)
                  then "--unix-socket ${address} http://unix"
                  else abort "Vault protocol is unix but address ${address} is not a valid path"
                )
              else "${protocol}://${address}:${toString port}";
            endpoint = "${addr}/v1/pki/issue/${authority.role}";
            payload = lib.generators.toJSON { } {
              common_name = CN;
              alt_names = commas (spec.request.hosts.dns or [ ]);
              ip_sans = commas (spec.request.hosts.ip or [ ]);
            };
            curlFlags = [
              "--silent"
              "--show-error"
              "--header"
              ("X-Vault-Token:${token}")
              "--request"
              "POST"
              "--data"
              (escapeShellArg payload)
            ];
          in
          {
            name = spec.service;
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
              };
              script = ''
                curl ${concatStringsSep " " curlFlags} ${endpoint} > cert.json
                if jq -e 'has("errors")' < cert.json > /dev/null; then
                  echo '<3>Certificate request failed with:'
                  jq -r '.errors | map("<3>  " + .)[]' < cert.json
                  exit 1
                fi
                if jq -e 'has("warnings")' < cert.json > /dev/null; then
                  echo '<4>Certificate created with warnings:'
                  jq -r '.warnings | map("<4>  " + .)[]' < cert.json
                fi
                jq -r .data.certificate < cert.json > certificate.pem
                jq -r .data.private_key < cert.json > private_key.pem
                jq -r .data.issuing_ca < cert.json > ca.pem
              '' + concatLines (
                mapAttrsToList (name: file: install "${name}.pem" file)
                  (getAttrs [ "certificate" "private_key" "ca" ] spec)
              );
            };
          }
        )
        specs;
    };
  imports = [
    ./server.nix
  ];
}
