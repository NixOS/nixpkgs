import ./make-test-python.nix (
  { lib, ... }@args:
  let
    pkgs = args.pkgs.extend (
      self: super: {
        stdenv = super.stdenv.override {
          config = super.config // {
            allowUnfreePredicate =
              pkg:
              builtins.elem (lib.getName pkg) [
                "vscode"
                "vscode-with-extensions"
                "vscode-extension-ms-vscode-remote-remote-ssh"
              ];
          };
        };
      }
    );

    inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;

    inherit (pkgs.vscode.passthru) rev vscodeServer;
  in
  {
    name = "vscode-remote-ssh";
    meta.maintainers = with lib.maintainers; [ Enzime ];

    nodes =
      let
        serverAddress = "192.168.0.2";
        clientAddress = "192.168.0.1";
      in
      {
        server =
          { ... }:
          {
            networking.interfaces.eth1.ipv4.addresses = [
              {
                address = serverAddress;
                prefixLength = 24;
              }
            ];
            services.openssh.enable = true;
            users.users.root.openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
            virtualisation.additionalPaths = with pkgs; [
              patchelf
              bintools
              stdenv.cc.cc.lib
            ];
          };
        client =
          { ... }:
          {
            imports = [
              ./common/x11.nix
              ./common/user-account.nix
            ];
            networking.interfaces.eth1.ipv4.addresses = [
              {
                address = clientAddress;
                prefixLength = 24;
              }
            ];
            networking.hosts.${serverAddress} = [ "server" ];
            test-support.displayManager.auto.user = "alice";
            environment.systemPackages = [
              (pkgs.vscode-with-extensions.override {
                vscodeExtensions = [
                  pkgs.vscode-extensions.ms-vscode-remote.remote-ssh
                ];
              })
            ];
          };
      };

    enableOCR = true;

    testScript =
      let
        jq = "${pkgs.jq}/bin/jq";

        sshConfig = builtins.toFile "ssh.conf" ''
          UserKnownHostsFile=/dev/null
          StrictHostKeyChecking=no
        '';

        vscodeConfig = builtins.toFile "settings.json" ''
          {
            "window.zoomLevel": 1,
            "security.workspace.trust.startupPrompt": "always"
          }
        '';
      in
      ''
        def connect_with_remote_ssh(screenshot, should_succeed):
          print(f"connect_with_remote_ssh({screenshot=}, {should_succeed=})")

          if server.execute("test -d ~/.vscode-server")[0] == 0:
            server.succeed("rm -r ~/.vscode-server")

          server.succeed("mkdir -p ~/.vscode-server/bin")
          server.succeed("cp -r ${vscodeServer} ~/.vscode-server/bin/${rev}")

          client.succeed("sudo -u alice code --remote=ssh-remote+root@server /root")
          client.wait_for_window("Visual Studio Code")

          client.wait_for_text("Do you trust the authors" if should_succeed else "Disconnected from SSH")
          client.screenshot(screenshot)

          if should_succeed:
            # Press the Don't Trust button
            client.send_key("tab")
            client.send_key("tab")
            client.send_key("tab")
            client.send_key("\n")
          else:
            # Close the error dialog
            client.send_key("esc")

          # Don't send Ctrl-q too quickly otherwise it might not get sent to VS Code
          client.sleep(1)
          client.send_key("ctrl-q")
          client.wait_until_fails("pidof code")


        start_all()
        server.wait_for_open_port(22)

        VSCODE_COMMIT = server.execute("${jq} -r .commit ${pkgs.vscode}/lib/vscode/resources/app/product.json")[1].rstrip()
        SERVER_COMMIT = server.execute("${jq} -r .commit ${vscodeServer}/product.json")[1].rstrip()

        print(f"{VSCODE_COMMIT=} {SERVER_COMMIT=}")
        assert VSCODE_COMMIT == SERVER_COMMIT, "VSCODE_COMMIT and SERVER_COMMIT do not match"

        client.wait_until_succeeds("ping -c1 server")
        client.succeed("sudo -u alice mkdir ~alice/.ssh")
        client.succeed("sudo -u alice install -Dm 600 ${snakeOilPrivateKey} ~alice/.ssh/id_ecdsa")
        client.succeed("sudo -u alice install ${sshConfig} ~alice/.ssh/config")
        client.succeed("sudo -u alice install -Dm 644 ${vscodeConfig} ~alice/.config/Code/User/settings.json")

        client.wait_for_x()
        client.wait_for_file("~alice/.Xauthority")
        client.succeed("xauth merge ~alice/.Xauthority")
        # Move the mouse out of the way
        client.succeed("${pkgs.xdotool}/bin/xdotool mousemove 0 0")

        with subtest("fails to connect when nixpkgs isn't available"):
          server.fail("nix-build '<nixpkgs>' -A hello")
          connect_with_remote_ssh(screenshot="no_node_installed", should_succeed=False)
          server.succeed("test -e ~/.vscode-server/bin/${rev}/node")
          server.fail("~/.vscode-server/bin/${rev}/node -v")

        with subtest("connects when server can patch Node"):
          server.succeed("mkdir -p /nix/var/nix/profiles/per-user/root/channels")
          server.succeed("ln -s ${pkgs.path} /nix/var/nix/profiles/per-user/root/channels/nixos")
          connect_with_remote_ssh(screenshot="build_node_with_nix", should_succeed=True)
      '';
  }
)
