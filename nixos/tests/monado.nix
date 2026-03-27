{ ... }:
{
  name = "monado";

  nodes.machine =
    { pkgs, ... }:

    {
      hardware.graphics.enable = true;
      users.users.alice = {
        isNormalUser = true;
        uid = 1000;
      };

      services.monado = {
        enable = true;
        defaultRuntime = true;

        forceDefaultRuntime = true;
      };
      # Stop Monado from probing for any hardware
      systemd.user.services.monado.environment.SIMULATED_ENABLE = "1";

      environment.systemPackages = with pkgs; [ openxr-loader ];
    };

  testScript =
    { nodes, ... }:
    let
      userId = toString nodes.machine.users.users.alice.uid;
      runtimePath = "/run/user/${userId}";
    in
    ''
      # for defaultRuntime
      machine.succeed("stat /etc/xdg/openxr/1/active_runtime.json")

      machine.succeed("loginctl enable-linger alice")
      machine.wait_for_unit("user@${userId}.service")

      machine.wait_for_unit("monado.socket", "alice")
      machine.systemctl("start monado.service", "alice")
      machine.wait_for_unit("monado.service", "alice")

      # for forceDefaultRuntime
      machine.succeed("stat /home/alice/.config/openxr/1/active_runtime.json")

      machine.succeed("su -- alice -c env XDG_RUNTIME_DIR=${runtimePath} openxr_runtime_list")
    '';
}
