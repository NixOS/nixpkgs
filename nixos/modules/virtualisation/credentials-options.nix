{ lib, pkgs, ... }:
{
  options.virtualisation.credentials = lib.mkOption {
    description = ''
      Credentials to pass to the VM or container using systemd's credential system.

      See {manpage}`systemd.exec(5)`, {manpage}`systemd-creds(1)` and https://systemd.io/CREDENTIALS/ for more
      information about systemd credentials.
    '';
    default = { };
    example = lib.literalExpression ''
      {
        database-password = {
          text = "my-secret-password";
        };
        ssl-cert = {
          source = "./cert.pem";
        };
        binary-key = {
          source = "./private.der";
        };
      }
    '';
    type = lib.types.attrsOf (
      lib.types.submodule (
        {
          name,
          options,
          config,
          ...
        }:
        {
          options = {
            source = lib.mkOption {
              type = lib.types.nullOr (lib.types.pathWith { });
              default = null;
              description = ''
                Source file on the host containing the credential data.
              '';
            };
            text = lib.mkOption {
              default = null;
              type = lib.types.nullOr lib.types.str;
              description = ''
                Text content of the credential.

                For binary data or when the credential content should come from
                an existing file, use `source` instead.

                ::: {.warning}
                The text here is stored in the host's nix store as a file.
                :::
              '';
            };
          };
          config.source = lib.mkIf (config.text != null) (
            lib.mkDerivedConfig options.text (pkgs.writeText name)
          );
        }
      )
    );
  };
}
