{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
, channelMap ? { # Maps "channels" to packages
    stable        = pkgs.microsoft-edge;
    beta          = pkgs.microsoft-edge-beta;
    dev           = pkgs.microsoft-edge-dev;
  }
}:
with import ../lib/testing-python.nix { inherit system pkgs; };

let
  user = "alice";
in

pkgs.lib.mapAttrs (channel: chromiumPkg: makeTest {
  name = "microsoft-edge-${channel}";
  meta = {
    maintainers = with pkgs.lib.maintainers; [ rhysmdnz ];
  };

  nodes.machine = {
    imports = [ ./common/user-account.nix ./common/x11.nix ];
    virtualisation.memorySize = 2047;
    test-support.displayManager.auto.user = user;
    environment = {
      systemPackages = [ chromiumPkg ];
      variables."XAUTHORITY" = "/home/alice/.Xauthority";
      etc."opt/edge/policies/managed/default.json".text = ''
        {"HideFirstRunExperience":true}
      '';
    };
  };

  enableOCR = true;

  testScript = (import ./chromium.nix { inherit system config pkgs channelMap; })."${channel}".testScript;
}) channelMap
