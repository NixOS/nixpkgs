import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    demo-program = pkgs.writeShellScriptBin "demo" ''
      while ${pkgs.coreutils}/bin/sleep 3; do
          echo Hello World > /dev/null
      done
    '';
    demo-service = pkgs.writeText "demo.service" ''
      [Unit]
      Description=demo service
      Requires=demo.socket
      After=demo.socket

      [Service]
      Type=simple
      ExecStart=${demo-program}/bin/demo
      Restart=always

      [Install]
      WantedBy=multi-user.target
      Also=demo.socket
    '';
    demo-socket = pkgs.writeText "demo.socket" ''
      [Unit]
      Description=demo socket

      [Socket]
      ListenStream=/run/demo.sock
      SocketMode=0666

      [Install]
      WantedBy=sockets.target
    '';
    demo-portable = pkgs.portableService {
      pname = "demo";
      version = "1.0";
      description = ''A demo "Portable Service" for a shell program built with nix'';
      units = [
        demo-service
        demo-socket
      ];
    };
  in
  {

    name = "systemd-portabled";
    nodes.machine = { };
    testScript = ''
      machine.succeed("portablectl")
      machine.wait_for_unit("systemd-portabled.service")
      machine.succeed("portablectl attach --now --runtime ${demo-portable}/demo_1.0.raw")
      machine.wait_for_unit("demo.service")
      machine.succeed("portablectl detach --now --runtime demo_1.0")
      machine.fail("systemctl status demo.service")
    '';
  }
)
