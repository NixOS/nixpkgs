import ./make-test-python.nix ({ pkgs, lib, ...}:

{
  name = "shiori";
  meta.maintainers = with lib.maintainers; [ minijackson ];

  nodes.machine =
    { ... }:
    { services.shiori.enable = true; };

  testScript = let
    authJSON = pkgs.writeText "auth.json" (builtins.toJSON {
      username = "shiori";
      password = "gopher";
      owner = true;
    });

  insertBookmark = {
    url = "http://example.org";
    title = "Example Bookmark";
  };

  insertBookmarkJSON = pkgs.writeText "insertBookmark.json" (builtins.toJSON insertBookmark);
  in ''
    import json

    machine.wait_for_unit("shiori.service")
    machine.wait_for_open_port(8080)
    machine.succeed("curl --fail http://localhost:8080/")
    machine.succeed("curl --fail --location http://localhost:8080/ | grep -i shiori")

    with subtest("login"):
        auth_json = machine.succeed(
            "curl --fail --location http://localhost:8080/api/login "
            "-X POST -H 'Content-Type:application/json' -d @${authJSON}"
        )
        auth_ret = json.loads(auth_json)
        session_id = auth_ret["session"]

    with subtest("bookmarks"):
        with subtest("first use no bookmarks"):
            bookmarks_json = machine.succeed(
                (
                    "curl --fail --location http://localhost:8080/api/bookmarks "
                    "-H 'X-Session-Id:{}'"
                ).format(session_id)
            )

            if json.loads(bookmarks_json)["bookmarks"] != []:
                raise Exception("Shiori have a bookmark on first use")

        with subtest("insert bookmark"):
            machine.succeed(
                (
                    "curl --fail --location http://localhost:8080/api/bookmarks "
                    "-X POST -H 'X-Session-Id:{}' "
                    "-H 'Content-Type:application/json' -d @${insertBookmarkJSON}"
                ).format(session_id)
            )

        with subtest("get inserted bookmark"):
            bookmarks_json = machine.succeed(
                (
                    "curl --fail --location http://localhost:8080/api/bookmarks "
                    "-H 'X-Session-Id:{}'"
                ).format(session_id)
            )

            bookmarks = json.loads(bookmarks_json)["bookmarks"]
            if len(bookmarks) != 1:
                raise Exception("Shiori didn't save the bookmark")

            bookmark = bookmarks[0]
            if (
                bookmark["url"] != "${insertBookmark.url}"
                or bookmark["title"] != "${insertBookmark.title}"
            ):
                raise Exception("Inserted bookmark doesn't have same URL or title")
  '';
})
