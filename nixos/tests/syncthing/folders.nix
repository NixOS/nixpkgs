{ lib, pkgs, ... }:
let
  genNodeId =
    name:
    pkgs.runCommand "syncthing-test-certs-${name}" { } ''
      mkdir -p $out
      ${pkgs.syncthing}/bin/syncthing generate --home=$out
      ${pkgs.libxml2}/bin/xmllint --xpath 'string(configuration/device/@id)' $out/config.xml > $out/id
    '';
  idA = genNodeId "a";
  idB = genNodeId "b";
  idC = genNodeId "c";
  nodeIdPath = nodeId: "${nodeId}/id";
  testPassword = "it's a secret";
  stCurl = pkgs.writeShellApplication {
    name = "st-curl";
    runtimeInputs = [ pkgs.curl ];
    text = ''
      exec curl -sSLk -H ${lib.escapeShellArg "X-API-Key: ${testPassword}"} \
        --retry 1000 --retry-delay 1 --retry-all-errors \
        "$@"
    '';
  };
in
{
  name = "syncthing";
  meta.maintainers = with pkgs.lib.maintainers; [ zarelit ];

  nodes = {
    a =
      { config, ... }:
      {
        environment.etc.bar-encryption-password.text = testPassword;
        environment.etc.gui-api-key.text = testPassword;
        environment.systemPackages = [
          stCurl
          pkgs.jq
        ];
        services.syncthing = {
          enable = true;
          openDefaultPorts = true;
          cert = "${idA}/cert.pem";
          key = "${idA}/key.pem";
          apiKeyFile = "/etc/gui-api-key";
          overrideFolders = false;
          overrideDevices = false;
          settings = {
            devices.b.id = lib.fileContents (nodeIdPath idB);
            devices.c.id = lib.fileContents (nodeIdPath idC);
            folders.foo = {
              path = "/var/lib/syncthing/foo";
              devices = [ "b" ];
            };
            folders.bar = {
              path = "/var/lib/syncthing/bar";
              devices = [
                {
                  name = "c";
                  encryptionPasswordFile = "/etc/${config.environment.etc.bar-encryption-password.target}";
                }
              ];
            };
            folders.baz = {
              path = "/var/lib/syncthing/baz";
              devices = [
                "b"
                "c"
              ];
              ignorePatterns = [ ];
            };
          };
        };
      };
    b =
      { config, ... }:
      {
        environment.etc.bar-encryption-password.text = testPassword;
        environment.etc.gui-api-key.text = testPassword;
        environment.systemPackages = [
          stCurl
          pkgs.jq
        ];
        services.syncthing = {
          enable = true;
          openDefaultPorts = true;
          cert = "${idB}/cert.pem";
          key = "${idB}/key.pem";
          apiKeyFile = "/etc/gui-api-key";
          overrideFolders = false;
          settings = {
            devices.a.id = lib.fileContents (nodeIdPath idA);
            devices.c.id = lib.fileContents (nodeIdPath idC);
            folders.foo = {
              path = "/var/lib/syncthing/foo";
              devices = [ "a" ];
            };
            folders.bar = {
              path = "/var/lib/syncthing/bar";
              devices = [
                {
                  name = "c";
                  encryptionPasswordFile = "/etc/${config.environment.etc.bar-encryption-password.target}";
                }
              ];
            };
            folders.baz = {
              path = "/var/lib/syncthing/baz";
              devices = [
                "a"
                "c"
              ];
              ignorePatterns = [
                "notB"
              ];
            };
          };
        };
      };
    c = {
      services.syncthing = {
        enable = true;
        openDefaultPorts = true;
        cert = "${idC}/cert.pem";
        key = "${idC}/key.pem";
        overrideFolders = false;
        settings = {
          devices.a.id = lib.fileContents (nodeIdPath idA);
          devices.b.id = lib.fileContents (nodeIdPath idB);
          folders.bar = {
            path = "/var/lib/syncthing/bar";
            devices = [
              "a"
              "b"
            ];
            type = "receiveencrypted";
          };
          folders.baz = {
            path = "/var/lib/syncthing/baz";
            devices = [
              "a"
              "b"
            ];
            ignorePatterns = [
              "notC"
            ];
          };
        };
      };
    };
  };

  testScript = # python
    ''
      import functools
      import json
      import shlex

      start_all()

      for n in (a, b, c):
        n.wait_for_unit("syncthing.service")
        n.wait_for_open_port(22000)

      # Test foo

      a.wait_for_file("/var/lib/syncthing/foo")
      b.wait_for_file("/var/lib/syncthing/foo")

      a.succeed("echo a2b > /var/lib/syncthing/foo/a2b")
      b.succeed("echo b2a > /var/lib/syncthing/foo/b2a")

      a.wait_for_file("/var/lib/syncthing/foo/b2a")
      b.wait_for_file("/var/lib/syncthing/foo/a2b")

      # Test bar

      a.wait_for_file("/var/lib/syncthing/bar")
      b.wait_for_file("/var/lib/syncthing/bar")
      c.wait_for_file("/var/lib/syncthing/bar")

      a.succeed("echo plaincontent > /var/lib/syncthing/bar/plainname")

      # Bar on C is untrusted, check that content is not in cleartext
      c.fail("grep -R plaincontent /var/lib/syncthing/bar")

      # Test baz

      a.wait_for_file("/var/lib/syncthing/baz")
      b.wait_for_file("/var/lib/syncthing/baz")
      c.wait_for_file("/var/lib/syncthing/baz")

      # A creates the file notB, C should get it, B should ignore it
      a.succeed("echo notB > /var/lib/syncthing/baz/notB")
      a.succeed("echo controlA > /var/lib/syncthing/baz/controlA")
      c.wait_for_file("/var/lib/syncthing/baz/notB")
      c.wait_for_file("/var/lib/syncthing/baz/controlA")
      b.wait_for_file("/var/lib/syncthing/baz/controlA")

      # B creates the file notC, A should get it, C should ignore it
      b.succeed("echo notC > /var/lib/syncthing/baz/notC")
      b.succeed("echo controlB > /var/lib/syncthing/baz/controlB")
      a.wait_for_file("/var/lib/syncthing/baz/notC")
      a.wait_for_file("/var/lib/syncthing/baz/controlB")
      c.wait_for_file("/var/lib/syncthing/baz/controlB")

      # Check that files have been correctly ignored
      b.fail("cat /var/lib/syncthing/baz/notB")
      c.fail("cat /var/lib/syncthing/baz/notC")

      # Through the Syncthing API:
      #
      # - On B: configure and share folder baz with A;
      # - On A: configure and share folder baz with B;
      # - On A: add device D.
      #
      # Then restart syncthing-init.service and
      # make sure that those changes are persisted.
      nodeIdA = a.succeed("cat ${nodeIdPath idA}").strip()
      nodeIdB = a.succeed("cat ${nodeIdPath idB}").strip()
      folder = "baz"

      def share_folder_with(nodeId: str) -> str:
        # Prepare an API request to create a new
        # folder and share it with the given node.
        return json.dumps({
          "autoNormalize": False, # upstream default is True
          "caseSensitiveFS": True, # upstream default is False
          "copyOwnershipFromParent":False,
          "devices": [
            {"deviceId": nodeId},
          ],
          "enable":True,
          "id": folder,
          "label": folder,
          "path": f"/var/lib/syncthing/{folder}",
          "type": "sendreceive",
          "versioning": None,
        })

      def pause_device_b(nodeId: str) -> str:
        return json.dumps({
          "paused": True,
          "deviceID": nodeIdB,
          "id": nodeIdB,
          "name": "b",
        })

      def post(what: str, node, req: str):
        cmd = shlex.join([
          "st-curl",
          "-X", "POST",
          "-d", req,
          f"127.0.0.1:8384/rest/config/{what}"
        ])
        return node.succeed(cmd)

      config_folders = functools.partial(post, "folders")
      config_devices = functools.partial(post, "devices")

      def check_folder(node):
        cmd = shlex.join(["st-curl", "127.0.0.1:8384/rest/config/folders"])
        folders = json.loads(node.succeed(cmd))
        def baz_only(f): return f["path"] == f"/var/lib/syncthing/{folder}"
        # the type check coerced me to use list...
        baz_folder = list(filter(baz_only, folders))
        how_many = len(baz_folder)
        assert how_many == 1, f"expected 1 {folder} folder (got {how_many})"
        case_sensitive_fs = baz_folder[0]["caseSensitiveFS"]
        auto_normalize = baz_folder[0]["autoNormalize"]
        assert case_sensitive_fs is True, f"caseSensitiveFS was reset to {case_sensitive_fs}"
        assert auto_normalize is False, f"autoNormalize was reset to {auto_normalize}"

      def check_device(node):
        cmd = shlex.join(["st-curl", "127.0.0.1:8384/rest/config/devices"])
        devices = json.loads(node.succeed(cmd))
        device_b = [d for d in devices if d["deviceID"] == nodeIdB]
        how_many = len(device_b)
        assert how_many == 1, f"expected 1 device for nodeID B (got {how_many})"
        assert device_b[0]["paused"] == True, "syncthing-init shouldn't have unpaused B"

      config_folders(a, share_folder_with(nodeIdB))
      config_folders(b, share_folder_with(nodeIdA))
      config_devices(a, pause_device_b(nodeIdB))

      check_folder(a)
      check_folder(b)
      check_device(a)

      a.systemctl("restart syncthing-init.service")
      b.systemctl("restart syncthing-init.service")

      check_folder(a)
      check_folder(b)
      check_device(a)
    '';
}
