{ pkgs, lib, ... }:

let
  settings = {
    album_art_pattern = "(cover|front|folder)\.(jpeg|jpg|png|bmp|gif)";
    users = [
      {
        name = "test_user1";
        initial_password = "very_secret_password1";
        admin = false;
      }
      {
        name = "test_user2";
        initial_password = "very_secret_password2";
        admin = true;
      }
    ];
    mount_dirs = [
      {
        name = "Media";
        source = "${pkgs.gridtracker}/share/gridtracker/media/";
      }
    ];
  };
in

{
  name = "polaris";
  meta.maintainers = with lib.maintainers; [ pbsds ];

  extraPythonPackages = ps: [ ps.addict ];

  nodes.machine = {
    services.polaris = {
      enable = true;
      port = 5050;
      inherit settings;
    };

    systemd.services.prepopulate-polaris-config = {
      wantedBy = [ "polaris.service" ];
      before = [ "polaris.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /var/lib/private/polaris/
        cat <<-"EOF" > /var/lib/private/polaris/config.toml
          album_art_pattern = "nope"
          foobar = "hello world"

          [[mount_dirs]]
          name = "i don't exist"
          source = "/foo"
        EOF
      '';
    };
  };

  testScript = ''
    import json, tomllib, shlex, time
    import addict # type: ignore
    from pathlib import Path

    machine.wait_for_unit("polaris.service")
    machine.wait_for_open_port(5050)

    def curl(method, *cmd_args, **data) -> str:
        cmd = [ "curl", "-X", method, *cmd_args ]
        if data:
            cmd += [ "-d", json.dumps(data) ]
        return machine.succeed(" ".join(map(shlex.quote, cmd))).rstrip()

    headers = [
      "-H", "accept: application/json",
      "-H", "Content-Type: application/json",
    ]

    # polaris nixos config
    settings = addict.Dict(json.loads("""${builtins.toJSON settings}"""))

    # test unauthenticated endpoints
    resp = curl("GET", "http://localhost:5050/api/version", *headers)
    assert resp, f"{resp=}"

    resp = curl("GET", "http://localhost:5050/api/initial_setup", *headers)
    assert json.loads(resp) == {"has_any_users": True}, resp

    resp = curl("GET", "http://localhost:5050/api-docs", *headers)
    assert resp, f"{resp=}"

    # test authenticated endpoints for failed access
    resp = curl("GET", "http://localhost:5050/api/browse", *headers)
    assert resp == "Authentication is required", f"{resp=}"

    resp = curl("GET", "http://localhost:5050/api/flatten", *headers)
    assert resp == "Authentication is required", f"{resp=}"

    resp = curl("GET", "http://localhost:5050/api/settings", *headers)
    assert resp == "Authentication is required", f"{resp=}"

    resp = curl("GET", "http://localhost:5050/api/mount_dirs", *headers)
    assert resp == "Authentication is required", f"{resp=}"

    resp = curl("POST", "http://localhost:5050/api/trigger_index", *headers)
    assert resp == "Authentication is required", f"{resp=}"

    # try all logins
    for user in settings.users:
        with machine.nested(f"User {user.name}"):
            resp = curl("POST", "http://localhost:5050/api/auth", *headers, username=user.name, password=user.initial_password)
            assert resp, f"{resp=}"
            data = json.loads(resp)
            assert data["username"] == user.name, f"{data["username"]=}, {user.name=}"
            assert data["is_admin"] == user.admin, f"{data["is_admin"]=}, {user.admin=}"

    # use last login
    assert user.admin
    assert data["token"], f"{data["token"]=}"
    headers += [ "-H", f"Authorization: Bearer {data["token"]}" ]

    # start scan for songs
    resp = curl("POST", "http://localhost:5050/api/trigger_index", *headers)
    print(f"{resp=}")

    # The test passes with no wait (takes 0.18 seconds),
    # but let's just be on the safe side
    time.sleep(10)

    # check config
    resp = curl("GET", "http://localhost:5050/api/settings", *headers)
    assert resp, "{resp=}"
    data = json.loads(resp)
    print(data)
    assert data["album_art_pattern"] == settings.album_art_pattern, \
        f"{data["album_art_pattern"]=}, {settings.album_art_pattern=}"

    resp = curl("GET", "http://localhost:5050/api/mount_dirs", *headers)
    assert set(
      item["name"]
      for item in json.loads(resp)
    ) == set(
      mount_dir.name
      for mount_dir in settings.mount_dirs
    ), "{resp=}"

    # browse
    songs = set(
      f"{mount_dir.name}/{fname.relative_to(mount_dir.source)}"
      for mount_dir in settings.mount_dirs
      for fname in Path(mount_dir.source).rglob("*.mp3")
    )
    assert any(songs), "no songs found"

    # list front page
    resp = curl("GET", "http://localhost:5050/api/browse", *headers)
    assert resp, "{resp=}"
    items = json.loads(resp)
    assert any(items), "{items=}"
    for item in items:
        if "Song" in item:
            assert item["Song"]["path"] in songs
        elif "Directory" in item and "/" not in ["path"]:
            assert item["Directory"]["path"] in [
              dir.name
              for dir in settings.mount_dirs
            ]

    # list all
    resp = curl("GET", "http://localhost:5050/api/flatten", *headers)
    assert resp, "{resp=}"
    items = json.loads(resp)
    assert any(items), "{items=}"
    for item in items:
        assert item["path"] in songs, f"{item["path"]=}"

    # debugging
    out = machine.succeed("find /var/lib/private/polaris/")
    print(out)
    out = machine.succeed("find /var/cache/private/polaris/")
    print(out)
    out = machine.succeed("cat /var/lib/private/polaris/config.toml")
    print(out)

    # check that foobar survived the config merge
    data = tomllib.loads(out)
    assert data["foobar"] == "hello world", f"{data["foobar"]=}"
  '';
}
