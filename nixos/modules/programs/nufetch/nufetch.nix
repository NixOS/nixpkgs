{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.programs.nufetch;
  configFile = pkgs.writeText "nufetch.conf" (import ./lib/config-maker.nix { inherit cfg lib; });
in
{

  config = lib.mkIf config.programs.nufetch.enable {
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "neofetch" ''
        exec ${lib.getExe pkgs.nufetch-for-nixos-module} --config /etc/nufetch.conf "$@"
      '')
      (pkgs.writeShellScriptBin "nufetch" ''
        exec ${lib.getExe pkgs.nufetch-for-nixos-module} --config /etc/nufetch.conf "$@"
      '')
      pkgs.nufetch-for-nixos-module
    ];
    environment.etc."nufetch.conf".source = configFile;
  };

  options.programs.nufetch = {
    enable = lib.mkEnableOption "Enable Neofetch with custom options, a command-line utility to display system information.";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nufetch-for-nixos-module;
      defaultText = "pkgs.nufetch-for-nixos-module";
      description = "Set version of nufetch package to use.";
    };
    os = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neofetch OS information display.";
    };
    host = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neofetch Host information display.";
    };
    kernel = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neofetch Kernel information display.";
    };
    uptime = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neofetch Uptime information display.";
    };
    packages = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable Neofetch Packages information display.";
    };
    shell = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neofetch Shell information display.";
    };
    resolution = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable Neofetch Resolution information display.";
    };
    de = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable Neofetch Desktop Environment information display.";
    };
    wm = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neofetch Window Manager information display.";
    };
    wm_theme = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable Neofetch Window Manager Theme information display.";
    };
    theme = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable Neofetch Theme information display.";
    };
    icons = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable Neofetch Icons display.";
    };
    terminal = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neofetch Terminal information display.";
    };
    terminal_font = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable Neofetch Terminal information display.";
    };
    cpu = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neofetch CPU information display.";
    };
    gpu = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neofetch GPU information display.";
    };
    memory = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neofetch Memory information display.";
    };
    cpu_usage = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable Neofetch CPU Usage information display.";
    };
    disk = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neofetch Disk information display.";
    };
    battery = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neofetch Battery information display.";
    };
    font = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable Neofetch Font information display.";
    };
    song = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable Neofetch Song information display.";
    };
    local_ip = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neofetch Local IP information display.";
    };
    public_ip = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable Neofetch Public IP information display.";
    };
    users = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable Neofetch Users information display.";
    };
    birthday = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Enable Neofetch Birthday information display.";
    };
    extraPrintInfoFields = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Extra config lines to append to the generated Neofetch config. Use a long string (e.g. '''') for multi-line content.";
    };
    extraGenericFields = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Extra config lines to append to the generated Neofetch config. Use a long string (e.g. '''') for multi-line content.";
    };
  };

  meta.maintainers = with lib.maintainers; [ gignsky ];
}
