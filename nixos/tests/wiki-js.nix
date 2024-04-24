import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "wiki-js";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes.machine = { pkgs, ... }: {
    virtualisation.memorySize = 2047;
    services.wiki-js = {
      enable = true;
      settings.db.host = "/run/postgresql";
      settings.db.user = "wiki-js";
      settings.db.db = "wiki-js";
      settings.logLevel = "debug";
    };
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "wiki-js" ];
      ensureUsers = [
        { name = "wiki-js";
          ensureDBOwnership = true;
        }
      ];
    };
    systemd.services.wiki-js = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };
    environment.systemPackages = with pkgs; [ jq ];
  };

  testScript = let
    payloads.finalize = pkgs.writeText "finalize.json" (builtins.toJSON {
      adminEmail = "webmaster@example.com";
      adminPassword = "notapassword";
      adminPasswordConfirm = "notapassword";
      siteUrl = "http://localhost:3000";
      telemetry = false;
    });
    payloads.login = pkgs.writeText "login.json" (builtins.toJSON [{
      operationName = null;
      extensions = {};
      query = ''
        mutation ($username: String!, $password: String!, $strategy: String!) {
          authentication {
            login(username: $username, password: $password, strategy: $strategy) {
              responseResult {
                succeeded
                errorCode
                slug
                message
                __typename
              }
              jwt
              mustChangePwd
              mustProvideTFA
              mustSetupTFA
              continuationToken
              redirect
              tfaQRImage
              __typename
            }
            __typename
          }
        }
      '';
      variables = {
        password = "notapassword";
        strategy = "local";
        username = "webmaster@example.com";
      };
    }]);
    payloads.content = pkgs.writeText "content.json" (builtins.toJSON [{
      extensions = {};
      operationName = null;
      query = ''
        mutation ($content: String!, $description: String!, $editor: String!, $isPrivate: Boolean!, $isPublished: Boolean!, $locale: String!, $path: String!, $publishEndDate: Date, $publishStartDate: Date, $scriptCss: String, $scriptJs: String, $tags: [String]!, $title: String!) {
          pages {
            create(content: $content, description: $description, editor: $editor, isPrivate: $isPrivate, isPublished: $isPublished, locale: $locale, path: $path, publishEndDate: $publishEndDate, publishStartDate: $publishStartDate, scriptCss: $scriptCss, scriptJs: $scriptJs, tags: $tags, title: $title) {
              responseResult {
                succeeded
                errorCode
                slug
                message
                __typename
              }
              page {
                id
                updatedAt
                __typename
              }
              __typename
            }
            __typename
          }
        }
      '';
      variables = {
        content = "# Header\n\nHello world!";
        description = "";
        editor = "markdown";
        isPrivate = false;
        isPublished = true;
        locale = "en";
        path = "home";
        publishEndDate = "";
        publishStartDate = "";
        scriptCss = "";
        scriptJs = "";
        tags = [];
        title = "Hello world";
      };
    }]);
  in ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_open_port(3000)

    machine.succeed("curl -sSf localhost:3000")

    with subtest("Setup"):
        result = machine.succeed(
            "curl -sSf localhost:3000/finalize -X POST -d "
            + "@${payloads.finalize} -H 'Content-Type: application/json' "
            + "| jq .ok | xargs echo"
        )
        assert result.strip() == "true", f"Expected true, got {result}"

        # During the setup the service gets restarted, so we use this
        # to check if the setup is done.
        machine.wait_until_fails("curl -sSf localhost:3000")
        machine.wait_until_succeeds("curl -sSf localhost:3000")

    with subtest("Base functionality"):
        auth = machine.succeed(
            "curl -sSf localhost:3000/graphql -X POST "
            + "-d @${payloads.login} -H 'Content-Type: application/json' "
            + "| jq '.[0].data.authentication.login.jwt' | xargs echo"
        ).strip()

        assert auth

        create = machine.succeed(
            "curl -sSf localhost:3000/graphql -X POST "
            + "-d @${payloads.content} -H 'Content-Type: application/json' "
            + f"-H 'Authorization: Bearer {auth}' "
            + "| jq '.[0].data.pages.create.responseResult.succeeded'|xargs echo"
        )
        assert create.strip() == "true", f"Expected true, got {create}"

    machine.shutdown()
  '';
})
