{ lib, config, pkgs, ... }:
let
  inherit (pkgs)
    writeText;
  inherit (lib)
    concatStringsSep
    escapeShellArg
    filterAttrs
    mapAttrs
    mapAttrsToList
    mkMerge
    mkOption
    optional
    optionals
    pipe
    stringLength
    types;
  cfg = config.security.certificates.authorities.local;
  modules = with types; {
    root.options = {
      CN = mkOption {
        type = str;
        description = "Common Name";
      };
    };
    settings.options = {
      root = mkOption {
        type = str;
        description = "Root certificate to use.";
        default = "default";
      };
    };
  };
in
{
  options = {
    security.certificates.authorities.local = with types; {
      roots = mkOption {
        type = attrsOf (submodule modules.root);
        default = { default = { CN = "Self Signed CA"; }; };
      };
      settings = mkOption {
        type = submodule modules.settings;
        default = { };
      };
    };
  };
  # TODO: Certificate renewal
  config =
    let
      # Self-signed root CA script, manually generated using OpenSSL to support
      # user-defined CN and potentially other features
      opensslCfg = writeText
        "cert-local-config"
        (lib.generators.toINI { } (
          {
            ca.default_ca = cfg.settings.root;
            req.x509_extensions = "v3_ca";
            policy_default = {
              commonName = "supplied";
              countryName = "optional";
              stateOrProvinceName = "optional";
              organizationName = "optional";
              organizationalUnitName = "optional";
              emailAddress = "optional";
            };
            v3_ca = {
              subjectKeyIdentifier = "hash";
              authorityKeyIdentifier = "keyid:always,issuer";
              basicConstraints = "critical, CA:true";
              keyUsage = "critical, digitalSignature, cRLSign, keyCertSign";
            };
          } // (mapAttrs
            (name: root:
              let
                dir = "$ENV::STATE_DIRECTORY/${name}";
              in
              {
                certificate = "${dir}/ca.cert.pem";
                private_key = "${dir}/ca.key.pem";
                database = "${dir}/index.txt";
                serial = "${dir}/serial";
                new_certs_dir = "${dir}";
                policy = "policy_default";
                default_md = "sha256";

                default_days = 365;
                copy_extensions = "copy";
              })
            cfg.roots
          )
        ));
      mkCommand = cmd: args: concatStringsSep " " ([ cmd ] ++ args);
      openssl = mkCommand "openssl";
      # Helper to create an appropriate install line
      install =
        src:
        { path
        , owner ? "$(id -u)"
        , group ? "$(id -g)"
        , mode ? "0600"
        }:
        mkCommand "${pkgs.coreutils}/bin/install" [
          "-Dv"
          "-o"
          owner
          "-g"
          group
          "-m"
          mode
          (escapeShellArg src)
          (escapeShellArg path)
        ];
      # Generate install lines for all needed files
      installs =
        { certificate
        , private_key
        , ca
        , request
        , authority
        , ...
        }:
        let
          inherit (authority.local) root;
          inherit (request) CN;
        in
        (optional
          (! isNull certificate)
          (install "./${CN}/cert.pem" certificate))
        ++ (optional
          (! isNull private_key)
          (install "./${CN}/key.pem" private_key))
        ++ (optional
          (! isNull ca)
          (install "./${root}/ca.cert.pem" ca));
      # base service config
      baseService = {
        wantedBy = [ "multi-user.target" ];
        path = [
          pkgs.openssl
          pkgs.util-linux
        ];
        serviceConfig = rec {
          User = "cert-local";
          DynamicUser = true;
          StateDirectory = User;
          WorkingDirectory = "%S/${StateDirectory}";
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };
    in
    {
      systemd.services = mkMerge (
        # Generate all local roots
        (mapAttrsToList
          (name: root: {
            "certificate-local@${name}" = mkMerge [
              baseService
              {
                description = "Generates CA roots for ";
                script = ''
                  mkdir -m 0700 -p ./${name}
                  touch ./${name}/index.txt
                  echo 00 > ./${name}/serial
                  ${openssl [
                    "req"
                    "-config" "${opensslCfg}"
                    "-x509"
                    "-nodes"
                    "-days"   "365"
                    "-newkey" "rsa:2048"
                    "-keyout" "${name}/ca.key.pem"
                    "-out"    "${name}/ca.cert.pem"
                    "-subj"   (escapeShellArg "/CN=${root.CN}")
                  ]}
                '';
              }
            ];
          })
          cfg.roots)
        # Generate requested certificates
        ++ (pipe config.security.certificates.specifications [
          # Get only the specifications with local as the authority
          (filterAttrs (_: spec: spec.authority ? local))
          # Generate services to create the certificates
          (mapAttrsToList (
            name: { authority, request, service, ... }@spec:
              let
                inherit (authority.local) root;
                path = file: escapeShellArg "./${request.CN}/${file}";
                SAN = concatStringsSep "," (
                  map (dns: "DNS:" + dns) request.hosts.dns
                  ++ map (ip: "IP:" + ip) request.hosts.ip
                );
                subjNameStr = pipe
                  (request.names // { inherit (request) CN; })
                  [
                    (mapAttrsToList (type: value: "${type}=${value}"))
                    (concatStringsSep "/")
                    (str: "/${str}")
                    escapeShellArg
                  ];
                genRequest = openssl ([
                  "req"
                  "-config"
                  "${opensslCfg}"
                  "-noenc"
                  "-newkey"
                  "rsa:2048"
                  "-keyout"
                  (path "key.pem")
                  "-subj"
                  subjNameStr
                ] ++ (
                  if ((stringLength SAN) > 0)
                  then [
                    "-addext"
                    (escapeShellArg "subjectAltName=${SAN}")
                  ]
                  else [ ]
                ));
                signRequest = openssl [
                  "ca"
                  "-batch"
                  "-config"
                  "${opensslCfg}"
                  "-name"
                  authority.local.root
                  "-out"
                  (path "cert.pem")
                  "-in"
                  "-"
                ];
              in
              {
                "${service}" = mkMerge [
                  baseService
                  {
                    requires = [ "certificate-local@${root}.service" ];
                    after = [ "certificate-local@${root}.service" ];
                    script = ''
                      mkdir -m 0700 -p ${path ""}
                      (
                        flock 99
                        ${genRequest} | ${signRequest}
                      ) 99> ./lock
                    '';
                    serviceConfig.ExecStartPost = (
                      map
                        (line: "+${line}")
                        (installs spec)
                    );
                  }
                ];
              }
          ))
        ])
      );
    };
}


