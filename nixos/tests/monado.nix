import ./make-test-python.nix ({ pkgs, ... }: {
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
      };
      # Stop Monado from probing for any hardware
      systemd.user.services.monado.environment.SIMULATED_ENABLE = "1";

      environment.systemPackages = with pkgs; [ openxr-loader ];
    };

  testScript = { nodes, ... }:
    let
      userId = toString nodes.machine.users.users.alice.uid;
      runtimePath = "/run/user/${userId}";
    in
    ''
      machine.succeed("loginctl enable-linger alice")
      machine.wait_for_unit("user@${userId}.service")

      machine.wait_for_unit("monado.socket", "alice")
      machine.systemctl("start monado.service", "alice")
      machine.wait_for_unit("monado.service", "alice")

      machine.succeed("su -- alice -c env XDG_RUNTIME_DIR=${runtimePath} openxr_runtime_list")
    '';
})
