{
  lib,
  feature,
  ...
}:
{
  name = "xdg-impure-${feature}";
  meta.maintainers = with lib.maintainers; [
    acidbong
  ];

  nodes.machine =
    { pkgs, ... }:
    {
      nix.nixPath = lib.mkOrder 0 [
        "nixpkgs=${lib.cleanSource pkgs.path}"
      ];
    };

  testScript =
    let
      key = "xdgConfigHome";
      finalKey = if (feature == "overlays") then key else "config.${key}";
      settings = ''{{ ${key} = \"{path}\"; }}'';
      finalSettings = if (feature == "config") then settings else "[(final: prev: ${settings})]";
    in
    /* py */ ''
      xdg_configs = dict(unset="", default="~/.config", custom="~/.cfg")
      yellow = "\033[0;33m"
      bold = "\033[1m"
      reset = "\033[0m"

      machine.wait_for_unit("nix-daemon.socket")
      for status, path in xdg_configs.items():
          print(
              f"{yellow}XDG_CONFIG_HOME is {bold}{status}{yellow} ({path or f"should default to {xdg_configs["default"]}"}){reset}"
          )
          machine.execute(f"mkdir -pv {path or xdg_configs["default"]}/nixpkgs")
          machine.execute(
              f"echo '${finalSettings}' > {path or xdg_configs["default"]}/nixpkgs/${feature}.nix"
          )
          pathFromNix = machine.succeed(
              f"env XDG_CONFIG_HOME={path} nix-instantiate --eval -E '(import <nixpkgs> {{}}).${finalKey}'"
          ).strip('"\n')
          print(f"{bold}expected:{reset} '{path}'")
          print(f"{bold}got:{reset} '{pathFromNix}'")
          assert path == pathFromNix
    '';
}
