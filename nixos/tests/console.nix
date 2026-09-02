{ ... }:
{
  name = "console";
  meta.maintainers = [ ];

  nodes =
    let
      # Temporary dirty workaround for nixpkgs/issues/286283
      # Point directly to pkgs.kbd (real files) rather than /etc/kbd/keymaps
      # (which goes through consoleEnv's buildEnv and contains only symlinks).
      # systemd-localed follows the directory symlink but not individual file
      # symlinks inside it, so buildEnv-based paths yield no usable keymaps.
      missingKeymapsWorkaround =
        { pkgs, ... }:
        {
          systemd.tmpfiles.rules = [
            "L /usr/share/keymaps - - - - ${pkgs.kbd}/share/keymaps"
          ];
        };
    in
    {
      node_static =
        { ... }:
        {
          imports = [ missingKeymapsWorkaround ];
          console.keyMap = "lt";
        };

      node_imperative =
        { ... }:
        {
          imports = [ missingKeymapsWorkaround ];
          console.keyMap = "lt";
          i18n.imperativeLocale = true;
        };
    };

  testScript =
    { ... }:
    ''
      node_static.wait_for_unit("dbus.socket")

      with subtest("static - declared keymap is reported by localectl"):
          node_static.succeed("localectl status | grep -q 'VC Keymap: lt'")

      with subtest("static - keymap reverts to declared value after reboot"):
          # Unlike localectl set-locale, vconsole_write_data() in systemd's
          # localed-util.c writes to a hardcoded /etc/vconsole.conf path rather
          # than respecting SYSTEMD_ETC_VCONSOLE_CONF, so the set-keymap call
          # itself always succeeds. The static guarantee is that NixOS activation
          # restores the symlink on reboot, reverting any runtime changes.
          node_static.succeed("localectl set-keymap fr")
          node_static.succeed("localectl status | grep -q 'VC Keymap: fr'")
          node_static.shutdown()
          node_static.wait_for_unit("dbus.socket")
          node_static.succeed("localectl status | grep -q 'VC Keymap: lt'")

      node_imperative.wait_for_unit("dbus.socket")

      with subtest("imperative - declared keymap is reported by localectl on first boot"):
          node_imperative.succeed("localectl status | grep -q 'VC Keymap: lt'")

      with subtest("imperative - localectl set-keymap changes the keymap"):
          node_imperative.succeed("localectl set-keymap --no-convert fr")
          node_imperative.succeed("localectl status | grep -q 'VC Keymap: fr'")

      with subtest("imperative - keymap change persists across reboot"):
          node_imperative.shutdown()
          node_imperative.wait_for_unit("dbus.socket")
          node_imperative.succeed("localectl status | grep -q 'VC Keymap: fr'")
    '';
}
