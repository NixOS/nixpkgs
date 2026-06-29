{ pkgs, lib, ... }:
{
  name = "gophernicus";
  meta.maintainers = with lib.maintainers; [ h7x4 ];

  nodes.machine =
    { options, ... }:
    {
      imports = [ ./common/user-account.nix ];

      environment.systemPackages = with pkgs; [
        phetch
      ];

      users.users = {
        alice.homeMode = "755";
        bob.homeMode = "755";
      };

      services.gophernicus = {
        enable = true;
        domain = "localhost";

        path = options.services.gophernicus.path.default ++ [
          (pkgs.writeScriptBin "hello" ''printf "aaaaaaa\n"'')
        ];

        filters = {
          txt = pkgs.writeShellScript "gophernicus-test-filter-script" ''
            cat "$1"
            echo "world"
          '';
          php = "${pkgs.php}/bin/php";
        };
      };
    };

  testScript =
    let
      alice-hello = pkgs.writeText "gophernicus-test-alice-hello" ''
        Hi!
      '';
      bob-hello = pkgs.writeText "gophernicus-test-bob-hello" ''
        Hello!
      '';
      bob-custom-command = pkgs.writeText "gophernicus-test-bob-custom-command" ''
        =hello
      '';
      bob-php-cgi = pkgs.writeText "gophernicus-test-bob-php-cgi" ''
        #!${lib.getExe pkgs.php}
        <?php echo "Result: " . (1 + 1); ?>
      '';
      bob-filtered = pkgs.writeText "gophernicus-test-bob-filtered" ''
        hello
      '';
      bob-php-non-cgi = pkgs.writeText "gophernicus-test-bob-php-non-cgi" ''
        <?php echo "Result: " . (1 + 1); ?>
      '';
    in
    ''
      machine.wait_for_unit("sockets.target")

      def phetch_or_fail(path: str) -> str:
          result = machine.succeed(f"phetch -r gopher://localhost/{path}")

          print("--- RESPONSE ---")
          print(result)
          print("----------------")

          assert "Error:" not in result, "Found error in fetched content"
          assert "command not found" not in result, "Found missing command error in fetched content"

          return result

      with subtest("Fetch root pages"):
          content = phetch_or_fail("")
          assert "Welcome to Gophernicus!" in content, "Content not rendered properly"

          content = phetch_or_fail("/server-status")
          assert "Total Accesses" in content, "Content not rendered properly"

          content = phetch_or_fail("/caps.txt")
          assert "This is an automatically generated caps file." in content, "Content not rendered properly"

      machine.succeed("runuser -u alice -- install -Dm755 -d /home/alice/public_gopher")
      machine.succeed("runuser -u bob -- install -Dm755 -d /home/bob/public_gopher")

      with subtest("Fetch user pages"):
          machine.succeed("runuser -u alice -- install -Dm644 '${alice-hello}' /home/alice/public_gopher/hello")
          machine.succeed("runuser -u bob -- install -Dm644 '${bob-hello}' /home/bob/public_gopher/world")
          phetch_or_fail("1~alice/hello")
          phetch_or_fail("1~bob/world")

      with subtest("Render gophermap with custom command"):
          machine.succeed("runuser -u bob -- install -Dm644 '${bob-custom-command}' /home/bob/public_gopher/custom/gophermap")
          content = phetch_or_fail("1~bob/custom")
          assert "aaaaaaa" in content, "Content not rendered properly"

      with subtest("Render php as cgi"):
          machine.succeed("runuser -u bob -- install -Dm755 '${bob-php-cgi}' /home/bob/public_gopher/cgi-bin/php-cgi.php")
          content = phetch_or_fail("1~bob/cgi-bin/php-cgi.php")
          assert "Result: 2" in content, "Content not rendered properly"

      with subtest("Render filters"):
          machine.succeed("runuser -u bob -- install -Dm644 '${bob-filtered}' /home/bob/public_gopher/filtered.txt")
          content = phetch_or_fail("1~bob/filtered.txt")
          assert "hello" in content, "Content not rendered properly"
          assert "world" in content, "Content not rendered properly"

          machine.succeed("runuser -u bob -- install -Dm644 '${bob-php-non-cgi}' /home/bob/public_gopher/filtered.php")
          content = phetch_or_fail("1~bob/filtered.php")
          assert "Result: 2" in content, "Content not rendered properly"
    '';
}
