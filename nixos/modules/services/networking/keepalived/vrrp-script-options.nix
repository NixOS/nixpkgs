{ lib }:

{
  options = {

    script = lib.mkOption {
      type = lib.types.str;
      example = lib.literalExpression ''"''${pkgs.curl} -f http://localhost:80"'';
      description = "(Path of) Script command to execute followed by args, i.e. cmd [args]...";
    };

    interval = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Seconds between script invocations.";
    };

    timeout = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = "Seconds after which script is considered to have failed.";
    };

    weight = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Following a failure, adjust the priority by this weight.";
    };

    rise = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = "Required number of successes for OK transition.";
    };

    fall = lib.mkOption {
      type = lib.types.int;
      default = 3;
      description = "Required number of failures for KO transition.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "keepalived_script";
      description = "Name of user to run the script under.";
    };

    group = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Name of group to run the script under. Defaults to user group.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra lines to be added verbatim to the vrrp_script section.";
    };

  };

}
