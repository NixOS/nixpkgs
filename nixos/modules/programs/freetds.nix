# Global configuration for freetds environment.

{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.environment.freetds;

in
{
  ###### interface

  options = {

    environment.freetds = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = lib.literalExpression ''
        { MYDATABASE = '''
            host = 10.0.2.100
            port = 1433
            tds version = 7.2
          ''';
        }
      '';
      description = ''
        Configure freetds database entries. Each attribute denotes
        a section within freetds.conf, and the value (a string) is the config
        content for that section. When at least one entry is configured
        the global environment variables FREETDSCONF, FREETDS and SYBASE
        will be configured to allow the programs that use freetds to find the
        library and config.
      '';

    };

  };

  ###### implementation

  config = lib.mkIf (builtins.length (builtins.attrNames cfg) > 0) {

    environment.variables.FREETDSCONF = "/etc/freetds.conf";
    environment.variables.FREETDS = "/etc/freetds.conf";
    environment.variables.SYBASE = "${pkgs.freetds}";

    environment.etc."freetds.conf" = {
      text = (
        lib.concatStrings (
          lib.mapAttrsToList (name: value: ''
            [${name}]
            ${value}
          '') cfg
        )
      );
    };

  };

}
