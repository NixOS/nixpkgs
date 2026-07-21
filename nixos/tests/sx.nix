{ pkgs, lib, ... }:
{
  name = "sx";
  meta.maintainers = with lib.maintainers; [
    thiagokokada
  ];

  nodes.machine =
    { ... }:
    {
      imports = [ ./common/user-account.nix ];

      environment.systemPackages = with pkgs; [ icewm ];

      services.getty.autologinUser = "alice";

      services.xserver = {
        enable = true;
        displayManager.sx.enable = true;
      };

      # Create sxrc file on login and start sx
      programs.bash.loginShellInit =
        # bash
        ''
          mkdir -p "$HOME/.config/sx"
          echo 'exec icewm' > "$HOME/.config/sx/sxrc"
          chmod +x "$HOME/.config/sx/sxrc"

          sx
        '';
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
    in
    # python
    ''
      start_all()

      machine.wait_for_unit("multi-user.target")

      xauthority = "${user.home}/.local/share/sx/xauthority"
      machine.wait_for_file(xauthority)
      machine.succeed(f"xauth merge {xauthority}")

      def icewm_is_visible(_last_try: bool) -> bool:
          # sx will set DISPLAY as the TTY number we started, in this case
          # TTY1:
          # https://github.com/Earnestly/sx/blob/master/sx#L41.
          # We can't use `machine.wait_for_window` here since we are running
          # X as alice and not root.
          return "IceWM" in machine.succeed("DISPLAY=:1 xwininfo -root -tree")

      # Adding a retry logic to increase reliability
      retry(icewm_is_visible)
    '';
}
