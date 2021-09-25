import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "syncthing";
  meta.maintainers = with pkgs.lib.maintainers; [ chkno ];

  nodes = rec {
    a = {
      environment.systemPackages = with pkgs; [ curl libxml2 syncthing ];
      services.syncthing = {
        enable = true;
        openDefaultPorts = true;
      };
    };
    b = a;
  };

  testScript = ''
    import json
    import shlex

    confdir = "/var/lib/syncthing/.config/syncthing"


    def addPeer(host, name, deviceID):
        APIKey = host.succeed(
            "xmllint --xpath 'string(configuration/gui/apikey)' %s/config.xml" % confdir
        ).strip()
        oldConf = host.succeed(
            "curl -Ssf -H 'X-API-Key: %s' 127.0.0.1:8384/rest/config" % APIKey
        )
        conf = json.loads(oldConf)
        conf["devices"].append({"deviceID": deviceID, "id": name})
        conf["folders"].append(
            {
                "devices": [{"deviceID": deviceID}],
                "id": "foo",
                "path": "/var/lib/syncthing/foo",
                "rescanIntervalS": 1,
            }
        )
        newConf = json.dumps(conf)
        host.succeed(
            "curl -Ssf -H 'X-API-Key: %s' 127.0.0.1:8384/rest/config -X PUT -d %s"
            % (APIKey, shlex.quote(newConf))
        )


    start_all()
    a.wait_for_unit("syncthing.service")
    b.wait_for_unit("syncthing.service")
    a.wait_for_open_port(22000)
    b.wait_for_open_port(22000)

    aDeviceID = a.succeed("syncthing -home=%s -device-id" % confdir).strip()
    bDeviceID = b.succeed("syncthing -home=%s -device-id" % confdir).strip()
    addPeer(a, "b", bDeviceID)
    addPeer(b, "a", aDeviceID)

    a.wait_for_file("/var/lib/syncthing/foo")
    b.wait_for_file("/var/lib/syncthing/foo")
    a.succeed("echo a2b > /var/lib/syncthing/foo/a2b")
    b.succeed("echo b2a > /var/lib/syncthing/foo/b2a")
    a.wait_for_file("/var/lib/syncthing/foo/b2a")
    b.wait_for_file("/var/lib/syncthing/foo/a2b")
  '';
})
