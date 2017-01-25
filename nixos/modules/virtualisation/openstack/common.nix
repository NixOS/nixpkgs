{ lib }:

with lib;

rec {
  # A shell script string helper to get the value of a secret at
  # runtime.
  getSecret = secretOption:
    if secretOption.storage == "fromFile"
    then ''$(cat ${secretOption.value})''
    else ''${secretOption.value}'';


  # A shell script string help to replace at runtime in a file the
  # pattern of a secret by its value.
  replaceSecret = secretOption: filename: ''
    sed -i "s/${secretOption.pattern}/${getSecret secretOption}/g" ${filename}
    '';

  # This generates an option that can be used to declare secrets which
  # can be stored in the nix store, or not. A pattern is written in
  # the nix store to represent the secret. The pattern can
  # then be overwritten with the value of the secret at runtime.
  mkSecretOption = {name, description ? ""}:
    mkOption {
      description = description;
      type = types.submodule ({
        options = {
          pattern = mkOption {
            type = types.str;
            default = "##${name}##";
            description = "The pattern that represent the secret.";
            };
          storage = mkOption {
            type = types.enum [ "fromNixStore" "fromFile" ];
            description = ''
            Choose the way the password is provisionned. If
            fromNixStore is used, the value is the password and it is
            written in the nix store. If fromFile is used, the value
            is a path from where the password will be read at
            runtime. This is generally used with <link
            xlink:href="https://nixos.org/nixops/manual/#opt-deployment.keys">
            deployment keys</link> of Nixops.
           '';};
            value = mkOption {
              type = types.str;
	      description = ''
	      If the storage is fromNixStore, the value is the password itself,
	      otherwise it is a path to the file that contains the password.
	      '';
	      };
            };});
  };
  
  databaseOption = name: {
    host = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        Host of the database.
      '';
    };

    name = mkOption {
      type = types.str;
      default = name;
      description = ''
        Name of the existing database.
      '';
    };

    user = mkOption {
      type = types.str;
      default = name;
      description = ''
        The database user. The user must exist and has access to
        the specified database.
      '';
    };
    password = mkSecretOption {
      name = name + "MysqlPassword";
      description = "The database user's password";};
  };
}
