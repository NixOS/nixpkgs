{ lib }:

with lib;
with lib.types;
{
  options = {

    script = mkOption {
      type = str;
      example = literalExpression ''"''${pkgs.curl} -f http://localhost:80"'';
      description = "(Path of) Script command to execute followed by args, i.e. cmd [args]...";
    };

    interval = mkOption {
      type = int;
      default = 1;
      description = "Seconds between script invocations.";
    };

    timeout = mkOption {
      type = int;
      default = 5;
      description = "Seconds after which script is considered to have failed.";
    };

    weight = mkOption {
      type = int;
      default = 0;
      description = "Following a failure, adjust the priority by this weight.";
    };

    rise = mkOption {
      type = int;
      default = 5;
      description = "Required number of successes for OK transition.";
    };

    fall = mkOption {
      type = int;
      default = 3;
      description = "Required number of failures for KO transition.";
    };

    user = mkOption {
      type = str;
      default = "keepalived_script";
      description = "Name of user to run the script under.";
    };

    group = mkOption {
      type = nullOr str;
      default = null;
      description = "Name of group to run the script under. Defaults to user group.";
    };

    extraConfig = mkOption {
      type = lines;
      default = "";
      description = "Extra lines to be added verbatim to the vrrp_script section.";
    };

  };

}
