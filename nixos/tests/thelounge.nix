import ./make-test-python.nix {
  name = "thelounge";

  nodes =
    let
      mkTestRunner =
        cfg: pkgs: pkgs.writers.writePython3Bin "test-runner"
          {
            libraries = [ pkgs.python3Packages.aiohttp ];
            flakeIgnore = [ "E271" "E303" "E501" "W293" ];
          }
          ''
            import aiohttp
            import asyncio
            import json
            import sys


            async def main():
                user = None
                password = None

                if len(sys.argv) > 2:
                    user = sys.argv[1]
                    password = sys.argv[2]

                async with aiohttp.ClientSession() as session:
                    async with session.ws_connect("http://localhost:9000/socket.io/?EIO=4&transport=websocket") as ws:
                        async for msg in ws:
                            if msg.type == aiohttp.WSMsgType.TEXT:
                                typ = msg.data[0]
                                data = msg.data[1:]

                                if typ == "2":
                                    await ws.send_str("3")
                                elif typ == "0":
                                    await ws.send_str("40")
                                elif typ == "4":
                                    typ = data[0]
                                    data = data[1:]

                                    if typ == "2":
                                        data = json.loads(data)
                                        event = data[0]
                                        payload = None

                                        if len(data) > 1:
                                            payload = data[1]

                                        if event == "configuration":
                                            assert ${pkgs.lib.optionalString (!cfg.public) "not"} payload["public"]

                                            ${pkgs.lib.optionalString ((builtins.length cfg.plugins) > 0) ''
                                              assert any([theme["name"] == "thelounge-theme-solarized" for theme in payload["themes"]])
                                            ''}

                                            await ws.send_str("42" + json.dumps(["changelog"]))
                                        elif event == "auth:start":
                                            payload = ["auth:perform", {"user": user, "password": password}]
                                            await ws.send_str("42" + json.dumps(payload))
                                        elif event == "changelog":
                                            assert payload["packages"] is False

                                            break


            asyncio.run(main())
          '';
    in
    {
      private = { config, pkgs, ... }: {
        services.thelounge = {
          enable = true;
          plugins = [ pkgs.theLoungePlugins.themes.solarized ];
          ensureUsers = {
            john = {
              hashedPassword = "$2b$11$SqnMvKNEERan67wC9pQZX.MnCX2yXsTjh/EM0RLwhuZWq.Y/rGFLu"; # password123
            };
            jane =
              let
                file = pkgs.writeTextFile {
                  name = "jane-password";
                  text = config.services.thelounge.ensureUsers.john.hashedPassword;
                };
              in
              {
                hashedPasswordFile = "${file}";
              };
          };
        };

        environment.systemPackages =
          let
            testRunner = mkTestRunner config.services.thelounge pkgs;
          in
          [ testRunner ];
      };

      public = { config, pkgs, ... }: {
        services.thelounge = {
          enable = true;
          public = true;
        };

        environment.systemPackages =
          let
            testRunner = mkTestRunner config.services.thelounge pkgs;
          in
          [ testRunner ];
      };
    };

  testScript = ''
    start_all()

    for machine in machines:
      machine.wait_for_unit("thelounge.service")
      machine.wait_for_open_port(9000)

    public.succeed("PYTHONUNBUFFERED=1 test-runner")
    private.succeed("PYTHONUNBUFFERED=1 test-runner john password123")
    private.succeed("PYTHONUNBUFFERED=1 test-runner jane password123")

    for command in ["install foo", "uninstall foo", "outdated", "upgrade"]:
        private.succeed(f"sudo -u thelounge thelounge {command} |& grep NixOS")
  '';
}
