import ./make-test-python.nix ({ lib, pkgs, ... }:

  {
    name = "jellyfin";
    meta.maintainers = with lib.maintainers; [ minijackson ];

    nodes.machine =
      { ... }:
      {
        services.jellyfin.enable = true;
        environment.systemPackages = with pkgs; [ ffmpeg ];
      };

    # Documentation of the Jellyfin API: https://api.jellyfin.org/
    # Beware, this link can be resource intensive
    testScript =
      let
        payloads = {
          auth = pkgs.writeText "auth.json" (builtins.toJSON {
            Username = "jellyfin";
          });
          empty = pkgs.writeText "empty.json" (builtins.toJSON { });
        };
      in
      ''
        import json
        from urllib.parse import urlencode

        machine.wait_for_unit("jellyfin.service")
        machine.wait_for_open_port(8096)
        machine.succeed("curl --fail http://localhost:8096/")

        machine.wait_until_succeeds("curl --fail http://localhost:8096/health | grep Healthy")

        auth_header = 'MediaBrowser Client="NixOS Integration Tests", DeviceId="1337", Device="Apple II", Version="20.09"'


        def api_get(path):
            return f"curl --fail 'http://localhost:8096{path}' -H 'X-Emby-Authorization:{auth_header}'"


        def api_post(path, json_file=None):
            if json_file:
                return f"curl --fail -X post 'http://localhost:8096{path}' -d '@{json_file}' -H Content-Type:application/json -H 'X-Emby-Authorization:{auth_header}'"
            else:
                return f"curl --fail -X post 'http://localhost:8096{path}' -H 'X-Emby-Authorization:{auth_header}'"


        with machine.nested("Wizard completes"):
            machine.wait_until_succeeds(api_get("/Startup/Configuration"))
            machine.succeed(api_get("/Startup/FirstUser"))
            machine.succeed(api_post("/Startup/Complete"))

        with machine.nested("Can login"):
            auth_result_str = machine.succeed(
                api_post(
                    "/Users/AuthenticateByName",
                    "${payloads.auth}",
                )
            )
            auth_result = json.loads(auth_result_str)
            auth_token = auth_result["AccessToken"]
            auth_header += f", Token={auth_token}"

            sessions_result_str = machine.succeed(api_get("/Sessions"))
            sessions_result = json.loads(sessions_result_str)

            this_session = [
                session for session in sessions_result if session["DeviceId"] == "1337"
            ]
            if len(this_session) != 1:
                raise Exception("Session not created")

            me_str = machine.succeed(api_get("/Users/Me"))
            me = json.loads(me_str)["Id"]

        with machine.nested("Can add library"):
            tempdir = machine.succeed("mktemp -d -p /var/lib/jellyfin").strip()
            machine.succeed(f"chmod 755 '{tempdir}'")

            # Generate a dummy video that we can test later
            videofile = f"{tempdir}/Big Buck Bunny (2008) [1080p].mkv"
            machine.succeed(f"ffmpeg -f lavfi -i testsrc2=duration=5 '{videofile}'")

            add_folder_query = urlencode(
                {
                    "name": "My Library",
                    "collectionType": "Movies",
                    "paths": tempdir,
                    "refreshLibrary": "true",
                }
            )

            machine.succeed(
                api_post(
                    f"/Library/VirtualFolders?{add_folder_query}",
                    "${payloads.empty}",
                )
            )


        def is_refreshed(_):
            folders_str = machine.succeed(api_get("/Library/VirtualFolders"))
            folders = json.loads(folders_str)
            print(folders)
            return all(folder["RefreshStatus"] == "Idle" for folder in folders)


        retry(is_refreshed)

        with machine.nested("Can identify videos"):
            items = []

            # For some reason, having the folder refreshed doesn't mean the
            # movie was scanned
            def has_movie(_):
                global items

                items_str = machine.succeed(
                    api_get(f"/Users/{me}/Items?IncludeItemTypes=Movie&Recursive=true")
                )
                items = json.loads(items_str)["Items"]

                return len(items) == 1

            retry(has_movie)

            video = items[0]["Id"]

            item_info_str = machine.succeed(api_get(f"/Users/{me}/Items/{video}"))
            item_info = json.loads(item_info_str)

            if item_info["Name"] != "Big Buck Bunny":
                raise Exception("Jellyfin failed to properly identify file")

        with machine.nested("Can read videos"):
            media_source_id = item_info["MediaSources"][0]["Id"]

            machine.succeed(
                "ffmpeg"
                + f" -headers 'X-Emby-Authorization:{auth_header}'"
                + f" -i http://localhost:8096/Videos/{video}/master.m3u8?mediaSourceId={media_source_id}"
                + " /tmp/test.mkv"
            )

            duration = machine.succeed(
                "ffprobe /tmp/test.mkv"
                + " -show_entries format=duration"
                + " -of compact=print_section=0:nokey=1"
            )

            if duration.strip() != "5.000000":
                raise Exception("Downloaded video has wrong duration")
      '';
  })
