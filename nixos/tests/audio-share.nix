{lib, ...}: {
  name = "audio-share";
  nodes = {
    machine_default = {...}: {
      imports = [./common/x11.nix];

      users.users.alice = {
        isNormalUser = true;
        extraGroups = ["audio" "video"];
      };

      services.pipewire = {
        enable = true;
        pulse.enable = true;
        alsa.enable = true;
      };

      security.rtkit.enable = true;

      services.audio-share.enable = true;
    };
  };
  testScript = ''
    machine_default.start()
    machine_default.wait_for_x()

    # Start a user session for alice so PipeWire has a session bus
    machine_default.succeed("loginctl enable-linger alice")
    machine_default.succeed("su - alice -c 'systemctl --user start pipewire pipewire-pulse'")
    machine_default.wait_for_unit("pipewire.service", user="alice")

    machine_default.wait_for_unit("audio-share.service")
    machine_default.wait_for_open_port(65530)
  '';
  meta.maintainers = with lib.maintainers; [wetrustinprize];
}
