let
  makeTest = import ./make-test-python.nix;
  galeneTestGroupsDir = "/var/lib/galene/groups";
  galeneTestGroupFile = "galene-test-config.json";
  galenePort = 8443;
in
{
  basic = makeTest (
    { pkgs, lib, ... }:
    let
      galeneTestGroupAdminName = "admin";
      galeneTestGroupAdminPassword = "1234";
    in
    {
      name = "galene-works";
      meta = {
        inherit (pkgs.galene.meta) maintainers;
        platforms = lib.platforms.linux;
      };

      nodes.machine =
        { config, pkgs, ... }:
        {
          imports = [ ./common/x11.nix ];

          services.xserver.enable = true;

          environment = {
            # https://galene.org/INSTALL.html
            etc.${galeneTestGroupFile}.source = (pkgs.formats.json { }).generate galeneTestGroupFile {
              op = [
                {
                  username = galeneTestGroupAdminName;
                  password = galeneTestGroupAdminPassword;
                }
              ];
              other = [ { } ];
            };

            systemPackages = with pkgs; [
              firefox
            ];
          };

          services.galene = {
            enable = true;
            insecure = true;
            httpPort = galenePort;
            groupsDir = galeneTestGroupsDir;
          };
        };

      enableOCR = true;

      testScript = ''
        machine.wait_for_x()

        with subtest("galene starts"):
            # Starts?
            machine.wait_for_unit("galene")

            # Keeps running after startup?
            machine.sleep(10)
            machine.wait_for_unit("galene")

            # Reponds fine?
            machine.succeed("curl -s -D - -o /dev/null 'http://localhost:${builtins.toString galenePort}' >&2")

        machine.succeed("cp -v /etc/${galeneTestGroupFile} ${galeneTestGroupsDir}/test.json >&2")
        machine.wait_until_succeeds("curl -s -D - -o /dev/null 'http://localhost:${builtins.toString galenePort}/group/test/' >&2")

        with subtest("galene can join group"):
            # Open site
            machine.succeed("firefox --new-window 'http://localhost:${builtins.toString galenePort}/group/test/' >&2 &")
            # Note: Firefox doesn't use a regular "-" in the window title, but "—" (Hex: 0xe2 0x80 0x94)
            machine.wait_for_window("Test — Mozilla Firefox")
            machine.send_key("ctrl-minus")
            machine.send_key("ctrl-minus")
            machine.send_key("alt-f10")
            machine.wait_for_text(r"(Galène|Username|Password|Connect)")
            machine.screenshot("galene-group-test-join")

            # Log in as admin
            machine.send_chars("${galeneTestGroupAdminName}")
            machine.send_key("tab")
            machine.send_chars("${galeneTestGroupAdminPassword}")
            machine.send_key("ret")
            machine.sleep(5)
            # Close "Remember credentials?" FF prompt
            machine.send_key("esc")
            machine.sleep(5)
            machine.wait_for_text(r"(Enable|Share|Screen)")
            machine.screenshot("galene-group-test-logged-in")
      '';
    }
  );
}
