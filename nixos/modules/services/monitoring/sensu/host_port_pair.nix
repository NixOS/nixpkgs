{ lib, name, defaultHost ? null, defaultPort ? null, options ? {} }:

{
  options = with lib; with types; {
    host = mkOption {
      type = str;
      default = defaultHost;
      description = "The hostname of ${name}";
    };

    port = mkOption {
      type = int;
      default = defaultPort;
      description = "The port of ${name}";
    };
  } // options;
}
