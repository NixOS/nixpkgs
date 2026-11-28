{ pkgs, ... }:
{
  name = "wiki-js-v3";

  imports = [ ./common.nix ];

  nodes.machine.services.wiki-js.package = pkgs.wiki-js_3;

  testScript =
    let
      payloads.changePassword = pkgs.writeText "changePassword.json" (
        builtins.toJSON {
          newPassword = "12345678";
        }
      );
      payloads.login = pkgs.writeText "login.json" (
        builtins.toJSON {
          username = "admin@example.com";
          password = "12345678";
        }
      );

      payloads.content = pkgs.writeText "content.json" (
        builtins.toJSON {
          alias = "";
          allowBacklinks = true;
          allowComments = true;
          allowContributions = true;
          allowGlossaryLinks = true;
          allowRatings = true;

          content = ''
            # Header

            Hello world!
          '';

          description = "Welcome to my wiki!";
          icon = "mdi:file-document-outline";
          iconColor = "";

          isBrowsable = true;
          isSearchable = true;
          isTemplate = false;

          localeRelations = [ ];
          password = "";
          publishEndDate = "";
          publishStartDate = "";
          publishState = "published";

          relations = [ ];

          scriptJsLoad = "";
          scriptJsUnload = "";
          scriptCss = "";

          showLastEditedBy = true;
          showSidebar = true;
          showTags = true;
          showToc = true;

          tags = [ ];
          title = "Hello world";

          tocDepth = {
            min = 1;
            max = 2;
          };

          reasonForChange = "";
          locale = "en";
          path = "home";
          editor = "markdown";
        }
      );
    in
    ''
      machine.start()
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_open_port(3000)

      machine.succeed("curl -sSf localhost:3000")
      site_id = machine.succeed("curl -sSf localhost:3000/_api/bootstrap?hostname=localhost | jq -j .site.id")
      strategy_id = machine.succeed("curl -sSf localhost:3000/_api/bootstrap?hostname=localhost | jq -j .site.authStrategies[0].id")
      with subtest("Setup"):
          login_continuation_token = machine.succeed(
              f"jq --arg strategyid {strategy_id} '.strategyId = $strategyid' ${payloads.login} "
              + f"| curl -sSf localhost:3000/_api/sites/{site_id}/auth/login -X PUT -d "
              + "@- -H 'Content-Type: application/json' "
              + "| jq -j .continuationToken"
          )

          result = machine.succeed(
              f"jq --arg strategyid {strategy_id} --arg continuationtoken {login_continuation_token} '.strategyId = $strategyid | .continuationToken = $continuationtoken' ${payloads.changePassword} "
              + f"| curl -d @- -sSf localhost:3000/_api/sites/{site_id}/auth/changePassword -X PUT "
              + "-H 'Content-Type: application/json' "
              + "| jq .ok | xargs echo"
          )
          assert result.strip() == "true", f"Expected true, got {result}"

          machine.wait_until_succeeds("curl -sSf localhost:3000")

      with subtest("Base functionality"):
          auth = machine.succeed(
              f"jq --arg strategyid {strategy_id} '.strategyId = $strategyid' ${payloads.login} "
              + f"| curl -c /tmp/cookies.txt -sSf localhost:3000/_api/sites/{site_id}/auth/login -X PUT -d "
              + "@- -H 'Content-Type: application/json' "
              + "| jq -j .ok"
          )

          assert auth.strip() == "true", f"Expected true, got {result}"

          create = machine.succeed(
              f"curl -b /tmp/cookies.txt -sSf localhost:3000/_api/sites/{site_id}/pages -X POST "
              + "-d @${payloads.content} -H 'Content-Type: application/json' "
              + "| jq -j '.ok'"
          )

          assert create.strip() == "true", f"Expected true, got {create}"

      machine.shutdown()
    '';
}
