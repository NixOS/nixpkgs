{ authorities
, pkgs
, config
, lib
, name
, ...
}:
let
  inherit (lib)
    escapeShellArg
    mkIf
    mkOption
    types
    ;
  inherit (authorities) local;
in
{
  options = {
    authority = mkOption {
      type = types.attrTag {
        local = mkOption {
          type = types.submodule {
            options.root = mkOption {
              type = types.str;
              description = "Root certificate to use.";
              default = "default";
            };
          };
        };
      };
    };
  };
  config = mkIf (config.authority ? local) {
    output.scripts.mkCertificate =
      let
        inherit (config.output.scripts) mkKey mkCSR doInstall;
        inherit (config.authority.local) root;
        path = file: escapeShellArg "./${name}/${file}";
        key = path "key.pem";
        crt = path "crt.pem";
        ca = escapeShellArg "${local.stateDir}/${root}/ca.cert.pem";
        signRequest = lib.cert.openssl.toShell "ca" {
          config = local.configFile;
          batch = true;
          name = root;
          "in" = "-";
        };
        app = pkgs.writeShellApplication {
          name = "certificate-${name}-mkCertificate";
          runtimeInputs = with pkgs; [
            flock
            openssl
          ];
          text = ''
            # shellcheck disable=SC2174 # intended behavior
            mkdir -m 0700 -p ${path ""}
            ${mkKey} > ${key}
            ${mkCSR} < ${key} | flock $CA_ROOT/lock ${signRequest} > ${crt}
            ${doInstall} ${key} ${crt} ${ca}
          '';
        };
      in
      "${app}/bin/certificate-${name}-mkCertificate";
  };
};
