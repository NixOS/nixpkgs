{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.swapspace;
  inherit (lib)
    types
    mkIf
    lib.mkOption
    mkPackageOption
    mkEnableOption
    ;
  inherit (pkgs)
    makeWrapper
    runCommand
    writeText
    ;
  configFile = writeText "swapspace.conf" (lib.generators.toKeyValue { } cfg.settings);
  userWrapper =
    runCommand "swapspace"
      {
        buildInputs = [ makeWrapper ];
      }
      ''
        mkdir -p "$out/bin"
        makeWrapper '${lib.getExe cfg.package}' "$out/bin/swapspace" \
          --add-flags "-c '${configFile}'"
      '';
in
{
  options.services.swapspace = {
    enable = lib.mkEnableOption "Swapspace, a dynamic swap space manager";
    package = lib.mkPackageOption pkgs "swapspace" { };
    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "-P"
        "-v"
      ];
      description = "Any extra arguments to pass to swapspace";
    };
    installWrapper = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        This will add swapspace wrapped with the generated config, to environment.systemPackages
      '';
    };
    settings = lib.mkOption {
      type = lib.types.submodule {
        options = {
          swappath = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/swapspace";
            description = "Location where swapspace may create and delete swapfiles";
          };
          lower_freelimit = lib.mkOption {
            type = lib.types.ints.between 0 99;
            default = 20;
            description = "Lower free-space threshold: if the percentage of free space drops below this number, additional swapspace is allocated";
          };
          upper_freelimit = lib.mkOption {
            type = lib.types.ints.between 0 100;
            default = 60;
            description = "Upper free-space threshold: if the percentage of free space exceeds this number, swapspace will attempt to free up swapspace";
          };
          freetarget = lib.mkOption {
            type = lib.types.ints.between 2 99;
            default = 30;
            description = ''
              Percentage of free space swapspace should aim for when adding swapspace.
              This should fall somewhere between lower_freelimit and upper_freelimit.
            '';
          };
          min_swapsize = lib.mkOption {
            type = lib.types.str;
            default = "4m";
            description = "Smallest allowed size for individual swapfiles";
          };
          max_swapsize = lib.mkOption {
            type = lib.types.str;
            default = "2t";
            description = "Greatest allowed size for individual swapfiles";
          };
          cooldown = lib.mkOption {
            type = lib.types.ints.unsigned;
            default = 600;
            description = ''
              Duration (roughly in seconds) of the moratorium on swap allocation that is instated if disk space runs out, or the cooldown time after a new swapfile is successfully allocated before swapspace will consider deallocating swap space again.
              The default cooldown period is about 10 minutes.
            '';
          };
          buffer_elasticity = lib.mkOption {
            type = lib.types.ints.between 0 100;
            default = 30;
            description = ''Percentage of buffer space considered to be "free"'';
          };
          cache_elasticity = lib.mkOption {
            type = lib.types.ints.between 0 100;
            default = 80;
            description = ''Percentage of cache space considered to be "free"'';
          };
        };
      };
      default = { };
      description = ''
        Config file for swapspace.
        See the options here: <https://github.com/Tookmund/Swapspace/blob/master/swapspace.conf>
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ (if cfg.installWrapper then userWrapper else cfg.package) ];
    systemd.packages = [ cfg.package ];
    systemd.services.swapspace = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = [
          ""
          "${lib.getExe cfg.package} -c ${configFile} ${utils.escapeSystemdExecArgs cfg.extraArgs}"
        ];
      };
    };
    systemd.tmpfiles.settings.swapspace = {
      ${cfg.settings.swappath}.d = {
        mode = "0700";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [
      Luflosi
      phanirithvij
    ];
  };
}
