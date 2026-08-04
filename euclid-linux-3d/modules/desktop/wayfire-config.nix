{ config, pkgs, lib, ... }:

{
  systemd.user.services.wayfire-config-defaults = {
    description = "Initialize default Wayfire configuration";

    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      mkdir -p ''${HOME}/.config
      if [ ! -f ''${HOME}/.config/wayfire.ini ]; then
        cat << 'EOF' > ''${HOME}/.config/wayfire.ini
[core]
plugins = alpha animate autostart blur command cube decoration expo fast-switcher fisheye grid idle invert move oswitch place resize rotate scale switcher vswitch window-rules wm-actions wobbly zoom

[autostart]
autostart_wf_shell = false

[command]
binding_terminal = <super> KEY_ENTER | <ctrl> <alt> KEY_T
command_terminal = gnome-terminal

binding_launcher = <super> KEY_SPACE | <alt> KEY_F2
command_launcher = wldash

binding_file_manager = <super> KEY_E
command_file_manager = nautilus

binding_screenshot = KEY_SYSRQ
command_screenshot = grim

[cube]
activate = <super> KEY_C
rotate_left = <super> <alt> KEY_LEFT
rotate_right = <super> <alt> KEY_RIGHT

[expo]
toggle = <super> KEY_W

[fast-switcher]
activate = <super> KEY_TAB

[wobbly]
spring_k = 8
friction = 3
mass = 50

[animate]
open_animation = zoom
close_animation = zoom

[blur]
method = kawase
kawase_iterations = 2
EOF
      fi
    '';
  };
}
