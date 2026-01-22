{ ... }:
{
  name = "dawarich-nixos";

  nodes.machine =
    { pkgs, ... }:
    {
      services.dawarich = {
        enable = true;
        localDomain = "localhost";
      };

      environment.etc.geojson.source = pkgs.fetchurl {
        url = "https://github.com/Freika/dawarich/raw/8c24764aa56a084e980e21bc2ffd13a72fd611db/spec/fixtures/files/geojson/export.json";
        hash = "sha256-qI00E5ixKTRJduAD+qB3JzvrpoJmC55llNtSiPVyxz4=";
      };
    };

  testScript = ''
    import json

    machine.wait_for_unit("dawarich.target")

    machine.wait_for_open_port(3000) # Web
    machine.succeed("curl --fail http://localhost/")

    # Get API key via ruby console
    api_key = machine.succeed("dawarich-rails runner \"puts User.find_by(email: 'demo@dawarich.app').api_key\"").strip().split("\n")[-1]

    res = machine.succeed(f"curl -f -H 'Authorization: Bearer {api_key}' http://localhost/api/v1/users/me")
    user_data = json.loads(res)
    assert user_data['user']['email'] == 'demo@dawarich.app'

    example_point = {
      "locations": [
        {
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [
              -122.40530871,
              37.74430413
            ]
          },
          "properties": {
            "battery_state": "full",
            "battery_level": 0.7,
            "wifi": "dawarich_home",
            "timestamp": "2025-01-17T21:03:01Z",
            "horizontal_accuracy": 5,
            "vertical_accuracy": -1,
            "altitude": 0,
            "speed": 92.088,
            "speed_accuracy": 0,
            "course": 27.07,
            "course_accuracy": 0,
            "track_id": "799F32F5-89BB-45FB-A639-098B1B95B09F",
            "device_id": "8D5D4197-245B-4619-A88B-2049100ADE46"
          }
        }
      ]
    }
    machine.succeed(f"curl -f -H 'Authorization: Bearer {api_key}' --json '{json.dumps(example_point)}' http://localhost/api/v1/points")

    res = machine.succeed(f"curl -f -H 'Authorization: Bearer {api_key}' http://localhost/api/v1/points")
    assert len(json.loads(res)) == 1

    # Test watcher job import
    import_dir = "/var/lib/dawarich/imports/watched/demo@dawarich.app"
    machine.succeed(f"mkdir -p {import_dir} && cp /etc/geojson {import_dir}/example.json")

    machine.succeed('dawarich-rails runner "Import::WatcherJob.perform_now"')
    # job runs in the background so doesn't update immediately
    res = machine.wait_until_succeeds(f"curl -f -H 'Authorization: Bearer {api_key}' http://localhost/api/v1/points | grep '\"id\":2'")
    assert len(json.loads(res)) == 11
  '';
}
