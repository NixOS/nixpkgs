{ lib } :

with lib;
with lib.types;
{
  options = {

    script = mkOption {
      type = str;
      example = literalExpression ''"''${pkgs.curl} -f http://localhost:80"'';
      description = lib.mdDoc "(Path of) Script command to execute followed by args, i.e. cmd [args]...";
    };

    interval = mkOption {
      type = int;
      default = 1;
      description = lib.mdDoc "Seconds between script invocations.";
    };

    timeout = mkOption {
      type = int;
      default = 5;
      description = lib.mdDoc "Seconds after which script is considered to have failed.";
    };

    weight = mkOption {
      type = int;
      default = 0;
      description = lib.mdDoc "Following a failure, adjust the priority by this weight.";
    };

    rise = mkOption {
      type = int;
      default = 5;
      description = lib.mdDoc "Required number of successes for OK transition.";
    };

    fall = mkOption {
      type = int;
      default = 3;
      description = lib.mdDoc "Required number of failures for KO transition.";
    };

    user = mkOption {
      type = str;
      default = "keepalived_script";
      description = lib.mdDoc "Name of user to run the script under.";
    };

    group = mkOption {
      type = nullOr str;
      default = null;
      description = lib.mdDoc "Name of group to run the script under. Defaults to user group.";
    };

    extraConfig = mkOption {
      type = lines;
      default = "";
      description = lib.mdDoc "Extra lines to be added verbatim to the vrrp_script section.";
    };

  };

}
