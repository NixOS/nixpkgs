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
      type = types.package;
      default = pkgs.nufetch-for-nixos-module;
      defaultText = "pkgs.nufetch-for-nixos-module";
      description = "Set version of nufetch package to use.";
    };
    os = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch OS information display.";
    };
    host = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Host information display.";
    };
    kernel = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Kernel information display.";
    };
    uptime = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Uptime information display.";
    };
    packages = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Packages information display.";
    };
    shell = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Shell information display.";
    };
    resolution = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Resolution information display.";
    };
    de = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Desktop Environment information display.";
    };
    wm = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Window Manager information display.";
    };
    wm_theme = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Window Manager Theme information display.";
    };
    theme = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Theme information display.";
    };
    icons = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Icons display.";
    };
    terminal = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Terminal information display.";
    };
    terminal_font = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Terminal information display.";
    };
    cpu = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch CPU information display.";
    };
    gpu = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch GPU information display.";
    };
    memory = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Memory information display.";
    };
    cpu_usage = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch CPU Usage information display.";
    };
    disk = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Disk information display.";
    };
    battery = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Battery information display.";
    };
    font = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Font information display.";
    };
    song = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Song information display.";
    };
    local_ip = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Local IP information display.";
    };
    public_ip = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Public IP information display.";
    };
    users = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Users information display.";
    };
    birthday = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Birthday information display.";
    };
    extraPrintInfoFields = lib.mkOption {
      type = types.str;
      default = "";
      description = "Extra config lines to append to the generated Neofetch config. Use a long string (e.g. '''') for multi-line content.";
    };
    extraGenericFields = lib.mkOption {
      type = types.str;
      default = "";
      description = "Extra config lines to append to the generated Neofetch config. Use a long string (e.g. '''') for multi-line content.";
    };
  };

  meta.maintainers = with maintainers; [ gignsky ];
}
