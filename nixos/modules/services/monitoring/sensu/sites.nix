{ lib }:

{
  options = with lib; {
    name = mkOption {
      type = types.str;
      default = "Site 1";
      description = "Name of the site.";
    };

    host = mkOption {
      type = types.str;
      default = "localhost";
      description = "Host name";
    };

    port = mkOption {
      type = types.int;
      default = 4567;
      description = "Port";
    };

    ssl = mkOption {
      type = types.bool;
      default = true;
      description = "Enable SSL";
    };

    insecure = mkOption {
      type = types.bool;
      default = true;
      description = "Insecure";
    };

    user = mkOption {
      type = types.str;
      default = "";
      description = "User name for authentication";
    };

    pass = mkOption {
      type = types.str;
      default = "";
      description = "Password for authentication";
    };

    path = mkOption {
      type = types.str;
      default = "";
      description = "Path?";
    };

    timeout = mkOption {
      type = types.int;
      default = 5;
      description = "Timeout";
    };
  };
}
