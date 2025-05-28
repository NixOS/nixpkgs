{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.programs.nufetch;
  configFile = pkgs.writeText "nufetch.conf" (import ./lib/config-maker.nix { inherit cfg lib; });
in
{

  config = mkIf config.programs.nufetch.enable {
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "neofetch" ''
        exec ${pkgs.nufetch-for-nixos-module}/bin/neofetch --config /etc/nufetch.conf "$@"
      '')
      (pkgs.writeShellScriptBin "nufetch" ''
        exec ${pkgs.nufetch-for-nixos-module}/bin/neofetch --config /etc/nufetch.conf "$@"
      '')
      pkgs.nufetch-for-nixos-module
    ];
    environment.etc."nufetch.conf".source = configFile;
  };

  options.programs.nufetch = {
    enable = mkEnableOption "Enable Neofetch with custom options, a command-line utility to display system information.";
    package = mkOption {
      type = types.package;
      default = pkgs.nufetch-for-nixos-module;
      defaultText = "pkgs.nufetch-for-nixos-module";
      description = "Set version of nufetch package to use.";
    };
    os = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch OS information display.";
    };
    host = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Host information display.";
    };
    kernel = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Kernel information display.";
    };
    uptime = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Uptime information display.";
    };
    packages = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Packages information display.";
    };
    shell = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Shell information display.";
    };
    resolution = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Resolution information display.";
    };
    de = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Desktop Environment information display.";
    };
    wm = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Window Manager information display.";
    };
    wm_theme = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Window Manager Theme information display.";
    };
    theme = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Theme information display.";
    };
    icons = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Icons display.";
    };
    terminal = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Terminal information display.";
    };
    terminal_font = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Terminal information display.";
    };
    cpu = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch CPU information display.";
    };
    gpu = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch GPU information display.";
    };
    memory = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Memory information display.";
    };
    cpu_usage = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch CPU Usage information display.";
    };
    disk = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Disk information display.";
    };
    battery = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Battery information display.";
    };
    font = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Font information display.";
    };
    song = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Song information display.";
    };
    local_ip = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Neofetch Local IP information display.";
    };
    public_ip = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Public IP information display.";
    };
    users = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Users information display.";
    };
    birthday = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neofetch Birthday information display.";
    };
    extraPrintInfoFields = mkOption {
      type = types.str;
      default = "";
      description = "Extra config lines to append to the generated Neofetch config. Use a long string (e.g. '''') for multi-line content.";
    };
    extraGenericFields = mkOption {
      type = types.str;
      default = "";
      description = "Extra config lines to append to the generated Neofetch config. Use a long string (e.g. '''') for multi-line content.";
    };
  };

  meta.maintainers = with maintainers; [ gignsky ];
}
