{ lib
, config
, options
, ...
}:
let
  inherit (builtins) hasAttr;
  inherit (lib) mkIf;
  cfg = config.hardware.cpu.x86.msr;
  opt = options.hardware.cpu.x86.msr;
  defaultGroup = "msr";
  isDefaultGroup = cfg.group == defaultGroup;
  set = "to set for devices of the `msr` kernel subsystem.";

  # Generates `foo=bar` parameters to pass to the kernel.
  # If `module = baz` is passed, generates `baz.foo=bar`.
  # Adds double quotes on demand to handle `foo="bar baz"`.
  kernelParam = { module ? null }: name: value:
    assert lib.asserts.assertMsg (!lib.strings.hasInfix "=" name) "kernel parameter cannot have '=' in name";
    let
      key = (if module == null then "" else module + ".") + name;
      valueString = lib.generators.mkValueStringDefault {} value;
      quotedValueString = if lib.strings.hasInfix " " valueString
        then lib.strings.escape ["\""] valueString
        else valueString;
    in "${key}=${quotedValueString}";
  msrKernelParam = kernelParam { module = "msr"; };
in
{
  options.hardware.cpu.x86.msr = with lib.options; with lib.types; {
    enable = mkEnableOption "the `msr` (Model-Specific Registers) kernel module and configure `udev` rules for its devices (usually `/dev/cpu/*/msr`)";
    owner = mkOption {
      type = str;
      default = "root";
      example = "nobody";
      description = "Owner ${set}";
    };
    group = mkOption {
      type = str;
      default = defaultGroup;
      example = "nobody";
      description = "Group ${set}";
    };
    mode = mkOption {
      type = str;
      default = "0640";
      example = "0660";
      description = "Mode ${set}";
    };
    settings = mkOption {
      type = submodule {
        freeformType = attrsOf (oneOf [ bool int str ]);
        options.allow-writes = mkOption {
          type = nullOr (enum ["on" "off"]);
          default = null;
          description = "Whether to allow writes to MSRs (`\"on\"`) or not (`\"off\"`).";
        };
      };
      default = {};
      description = "Parameters for the `msr` kernel module.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = hasAttr cfg.owner config.users.users;
        message = "Owner '${cfg.owner}' set in `${opt.owner}` is not configured via `${options.users.users}.\"${cfg.owner}\"`.";
      }
      {
        assertion = isDefaultGroup || (hasAttr cfg.group config.users.groups);
        message = "Group '${cfg.group}' set in `${opt.group}` is not configured via `${options.users.groups}.\"${cfg.group}\"`.";
      }
    ];

    boot = {
      kernelModules = [ "msr" ];
      kernelParams = lib.attrsets.mapAttrsToList msrKernelParam (lib.attrsets.filterAttrs (_: value: value != null) cfg.settings);
    };

    users.groups.${cfg.group} = mkIf isDefaultGroup { };

    services.udev.extraRules = ''
      SUBSYSTEM=="msr", OWNER="${cfg.owner}", GROUP="${cfg.group}", MODE="${cfg.mode}"
    '';
  };

  meta = with lib; {
    maintainers = with maintainers; [ lorenzleutgeb ];
  };
}
