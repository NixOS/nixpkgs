{ lib }:
with lib.types;
{
  options = {

    script = lib.mkOption {
      type = str;
      example = lib.literalExpression ''"''${pkgs.curl} -f http://localhost:80"'';
      description = "(Path of) Script command to execute followed by args, i.e. cmd [args]...";
    };

    interval = lib.mkOption {
      type = int;
      default = 1;
      description = "Seconds between script invocations.";
    };

    timeout = lib.mkOption {
      type = int;
      default = 5;
      description = "Seconds after which script is considered to have failed.";
    };

    weight = lib.mkOption {
      type = int;
      default = 0;
      description = "Following a failure, adjust the priority by this weight.";
    };

    rise = lib.mkOption {
      type = int;
      default = 5;
      description = "Required number of successes for OK transition.";
    };

    fall = lib.mkOption {
      type = int;
      default = 3;
      description = "Required number of failures for KO transition.";
    };

    user = lib.mkOption {
      type = str;
      default = "keepalived_script";
      description = "Name of user to run the script under.";
    };

    group = lib.mkOption {
      type = nullOr str;
      default = null;
      description = "Name of group to run the script under. Defaults to user group.";
    };

    extraConfig = lib.mkOption {
      type = lines;
      default = "";
      description = "Extra lines to be added verbatim to the vrrp_script section.";
    };

  };

}
