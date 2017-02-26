{ lib }:

{
  options = with lib; with types; {
    command = mkOption {
      default = "";
      description = "Command for mutator.";
      type = str;
    };

    timeout = mkOption {
      default = 30;
      description = "Timeout.";
      type = int;
    };
  };
}
