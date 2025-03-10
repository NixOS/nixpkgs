import ./make-test-python.nix (
  { ... }:
  {
    name = "monado";

    nodes.machine =
      { pkgs, ... }:

      {
        hardware.graphics.enable = true;
        users.users.alice = {
          isNormalUser = true;
          linger = true;
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
        user = nodes.machine.users.users.alice;
        runtimeUID = "$(id -u ${user.name})";
        runtimePath = "/run/user/${runtimeUID}";
      in
      ''
        # for defaultRuntime
        machine.succeed("stat /etc/xdg/openxr/1/active_runtime.json")

        machine.wait_for_unit("user@${runtimeUID}.service")

        machine.wait_for_unit("monado.socket", "${user.name}")
        machine.systemctl("start monado.service", "${user.name}")
        machine.wait_for_unit("monado.service", "${user.name}")

        # for forceDefaultRuntime
        machine.succeed("stat ~${user.name}/.config/openxr/1/active_runtime.json")

        machine.succeed("su -- ${user.name} -c env XDG_RUNTIME_DIR=${runtimePath} openxr_runtime_list")
      '';
  }
)
