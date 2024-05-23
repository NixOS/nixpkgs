import ./make-test-python.nix (
  { lib, pkgs, ... }:
  let
    expectedConfig = pkgs.writeText "keymapper.conf" ''
      @forward-modifiers Shift Control Alt

      Alt = AltLeft
      AltGr = AltRight
      Super = Meta

      ScrollLock >> CapsLock
      CapsLock >> Escape
      Alt{C} >> edit_copy
      Alt{V} >> edit_paste

      [stage]

      [class="kitty" system!="Darwin"]
      edit_copy >> Control{Shift{C}}
      edit_paste >> Control{Shift{V}}
    '';
  in
  {
    name = "keymapper";
    meta.maintainers = with lib.maintainers; [ spitulax ];

    nodes.machine.services.keymapper = {
      enable = true;
      aliases = {
        "Alt" = "AltLeft";
        "AltGr" = "AltRight";
        "Super" = "Meta";
      };
      contexts = [
        {
          mappings = [
            {
              input = "ScrollLock";
              output = "CapsLock";
            }
            {
              input = "CapsLock";
              output = "Escape";
            }
            {
              input = "Alt{C}";
              output = "edit_copy";
            }
            {
              input = "Alt{V}";
              output = "edit_paste";
            }
          ];
        }
        { stage = true; }
        {
          class = "kitty";
          nosystem = "Darwin";
          mappings = [
            {
              input = "edit_copy";
              output = "Control{Shift{C}}";
            }
            {
              input = "edit_paste";
              output = "Control{Shift{V}}";
            }
          ];
        }
      ];
    };

    testScript = ''
      machine.wait_for_unit("keymapperd.service")
      machine.wait_for_file("/etc/keymapper.conf")
      machine.succeed("keymapper --check")
      machine.copy_from_host("${expectedConfig}", "/tmp/keymapper.conf")
      print(machine.succeed("diff /etc/keymapper.conf /tmp/keymapper.conf"))
    '';
  }
)
