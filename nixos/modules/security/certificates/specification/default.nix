{ lib
, defaultAuthority
, config
, pkgs
, name
, ...
}:
let
  inherit (lib)
    concatLines
    concatMapAttrs
    escapeShellArg
    isAttrs
    isStringLike
    optional
    mapAttrs
    mkMerge
    mkOption
    types
    ;
in
{
  imports = [
    ./privateKey.nix
    ./extensions
  ];

  options = {
    inherit name;
    service = mkOption {
      type = types.str;
      description = ''
        The systemd service that will become `active` once the certificate is
        installed and ready for use.
        ::: {.note}
        This option is generally set by the authority and should not be
        changed by the user.
        :::
      '';
      default = "certificate-${name}";
    };
    subject = mkOption {
      type = with types; attrsOf str;
      description = "X.509 Subject fields";
      example = ''
        {
          CN = "*.nixos.org";
        }
      '';
    };
    install =
      let
        mkFileOption = description: mkOption {
          inherit description;
          type = types.submodule {
            options = {
              path = mkOption {
                type = types.path;
                description = "The path to create the file at.";
                example = "/var/lib/myservice/cert.pem";
              };
              owner = mkOption {
                type = types.str;
                description = "Owner of the created file";
                default = "root";
              };
              group = mkOption {
                type = types.str;
                description = "Group of the created file";
                default = "root";
              };
              mode = mkOption {
                type = types.str;
                description = "Octal permissions for the created file";
                default = "0400";
                example = "0440";
              };
            };
          };
        };
      in
      {
        certificate = mkFileOption
          "File to place the issued certificate at.";
        privateKey = mkFileOption
          "File to place the private key at.";
        authority = mkFileOption
          "File to place the issuers public certificate at at.";
      };

    authority = mkOption {
      type = types.attrTag { };
      description = ''
        Authority used to provide the certificate.
      '';
      default = {
        "${defaultAuthority}" = { };
      };
      defaultText = lib.literalExpression "config.security.certificates.defaultAuthority";
    };
    output = mkOption {
      type = types.submodule {
        options = {
          openssl = {
            config = mkOption {
              type = lib.cert.openssl.config.type;
              description = ''
                The resultant CSR structures as a OpenSSL config file. suitable for
                passing to `openssl req`.
                ::: {.note}
                This will typically be used to generate `configFile` and auto
                generated from the certificate specification.
                :::
              '';
              visible = false;
            };

            configFile = mkOption {
              type = types.path;
              description = ''
                A OpenSSL config file that when passed to `openssl req` will result in
                a "Certificate Signing Request" corresponding to the specification.
                ::: {.note}
                This will typically be auto generated from `config`
                :::
              '';
              visible = false;
            };
          };

          scripts = {
            mkCSR = mkOption {
              type = types.pathInStore;
              description = ''
                A executable that when run will read the private key on stdin and output
                a Certificate Signing Request on stdout in PEM format.
                ::: {.warn}
                Store objects are world readable and MUST not contain any secrets. As
                such keys and certificates are generated at runtime not buildtime.
                :::
              '';
              visible = false;
            };

            mkKey = mkOption {
              type = types.pathInStore;
              description = ''
                A executable that when run will produce a private key on stdout in PEM
                format.
                ::: {.warn}
                Store objects are world readable and MUST not contain any secrets. As
                such keys and certificates are generated at runtime not buildtime.
                :::
              '';
            };

            doInstall = mkOption {
              type = types.pathInStore;
              description = ''
                A executable that takes 3 path arguments to the private key file,
                certificate file, and certificate authority certificate file. Then
                copies those file to their destinations ensuring correct permissions.
              '';
            };

            mkCertificate = mkOption {
              type = types.pathInStore;
              description = ''
                A runnable that will generate and sign (by the appropriate authority)
                the certificate then install the files as needed.
                This option should be set by the specified authority module.
                ::: {.note}
                The script will be executed within it's own private temporary
                directory. Any files left in that directory will NOT be persisted
                :::
              '';
            };
          };
        };
      };
      description = ''
        Configuration files and scripts for generating the desired CSR as well
        as installing the resultant certificate files. Intended for internal use
        but may be overridden if necessary.
      '';
    };
  };

  config =
    let
      out = config.output;
      openssl = cmd: args: "${pkgs.openssl}/bin/${lib.cert.openssl.toShell cmd args}";
      mkCertScript = subName: runtimeInputs: text:
        let
          fullName = "certificate-${name}-${subName}";
          app = pkgs.writeShellApplication {
            inherit runtimeInputs text;
            name = fullName;
          };
        in
        "${app}/bin/${fullName}";
    in
    {
      output = {
        openssl = {
          config = mkMerge [
            {
              req = {
                prompt = "no";
                distinguished_name = "req_distinguishedName";
                req_extensions = "req_extensions";
              };

              # Distinguished Name (Subject)
              req_distinguishedName = config.subject;

              # Extensions
              req_extensions = mapAttrs
                (n: v:
                  if isStringLike v then (toString v)
                  else if isAttrs v && (v ? _value) then
                    (
                      if v.critical or true
                      then "critical, ${v._value}"
                      else v._value
                    )
                  else abort "Cannot convert extension ${n} to string")
                config.extensions;
            }
            # Collect extra sections from extensions
            (concatMapAttrs
              (_: v:
                if isAttrs v
                then v._extraSections or { }
                else { })
              config.extensions)
          ];

          configFile = pkgs.writeText "certificate-${name}-openssl.cnf" (
            lib.cert.openssl.config.generate out.openssl.config
          );
        };
        scripts = {
          mkCSR =
            let
              cfgFile = out.openssl.configFile;
            in
            mkCertScript "mkCSR"
              [ pkgs.openssl ]
              (openssl "req" {
                config = cfgFile;
                outform = "PEM";
                batch = true;
                new = true;
                key = "/dev/stdin";
              });
          doInstall =
            let
              files = config.install;
              install =
                src:
                { path
                , owner ? "$(id -u)"
                , group ? "$(id -g)"
                , mode ? "0600"
                ,
                }:
                "${pkgs.coreutils}/bin/install ${
                  lib.cli.toGNUCommandLineShell { } {
                    inherit owner group mode;
                    D = true;
                    verbose = true;
                    compare = true;
                  }
                } \"${src}\" ${escapeShellArg path}";
              text = concatLines (
                [
                  ''
                    PKEY=''${1:-/dev/null}
                    CERT=''${2:-/dev/null}
                    CA=''${3:-/dev/null}
                  ''
                ]
                ++ (optional (files ? privateKey)
                  (install "$PKEY" files.privateKey))
                ++ (optional (files ? certificate)
                  (install "$CERT" files.certificate))
                ++ (optional (files ? authority)
                  (install "$CA" files.authority))
              );
            in
            mkCertScript "doInstall"
              [ pkgs.openssl ]
              text;
        };
      };
    };
}
