{ pkgs, lib, ... }:
let
  hubPort = 1511;
  rpcPort = 3121;
  filePort = 1412;
  hubUrl = "adc://hub:${toString hubPort}";

  # eiskaltdcpp seeds MT19937 with a constant, so two fresh daemons generate the
  # same CID and the second login is rejected with "CID is taken". Pre-bake distinct,
  # base32-valid PRIVATE_IDs (decode to a non-zero CID).
  mkConfig =
    nick: pid:
    pkgs.writeText "DCPlusPlus.xml" ''
      <?xml version="1.0" encoding="utf-8"?>
      <DCPlusPlus><Settings>
      <Nick>${nick}</Nick>
      <CID>${pid}</CID>
      <DownloadDirectory>/var/lib/dcpp/dl/</DownloadDirectory>
      <InPort>${toString filePort}</InPort>
      </Settings></DCPlusPlus>
    '';

  client = nick: pid: tmpfilesExtra: {
    networking.firewall.enable = false; # peer-to-peer uses dynamic ports
    users.users.dcpp = {
      isSystemUser = true;
      group = "dcpp";
      home = "/var/lib/dcpp";
    };
    users.groups.dcpp = { };
    systemd.tmpfiles.rules = [
      "d /var/lib/dcpp/cfg 0755 dcpp dcpp -"
      "d /var/lib/dcpp/share 0755 dcpp dcpp -"
      "d /var/lib/dcpp/dl 0755 dcpp dcpp -"
    ]
    ++ tmpfilesExtra;
    systemd.services.dcpp = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "dcpp";
        Group = "dcpp";
        ExecStartPre = "${pkgs.coreutils}/bin/install -m 0644 ${mkConfig nick pid} /var/lib/dcpp/cfg/DCPlusPlus.xml";
        ExecStart = "${lib.getExe' pkgs.eiskaltdcpp "eiskaltdcpp-daemon"} -L 127.0.0.1 -P ${toString rpcPort} -c /var/lib/dcpp/cfg";
      };
    };
  };
in
{
  name = "uhub";
  meta.maintainers = with lib.maintainers; [ makefu ];

  nodes = {
    hub = {
      services.uhub.testhub.settings = {
        server_port = hubPort;
        server_bind_addr = "0.0.0.0";
        hub_name = "test";
        hub_description = "test";
      };
      networking.firewall.allowedTCPPorts = [ hubPort ];
    };
    uploader = client "up" "YHMAOGNQAAYLQVXMIW6K2BZLQDGVJPZWXNBYWOA" [
      "f /var/lib/dcpp/share/testfile.txt 0644 dcpp dcpp - hello-dcpp-payload"
    ];
    downloader = client "dl" "W5BCVQQKSTDVFTL6W45UZDS34WLWLDBDJ4E3FJA" [ ];
  };

  testScript = ''
    import json

    HUB = "${hubUrl}"

    def rpc(node, method, params=None):
        payload = json.dumps({"jsonrpc": "2.0", "id": "1", "method": method, "params": params or {}})
        out = node.succeed(
            f"curl -sS -X POST --data-binary {payload!r} http://127.0.0.1:${toString rpcPort}/"
        )
        return json.loads(out)["result"]

    start_all()
    hub.wait_for_unit("uhub-testhub.service")
    for c in [uploader, downloader]:
        c.wait_for_open_port(${toString rpcPort})

    rpc(uploader, "share.add", {"directory": "/var/lib/dcpp/share/", "virtname": "shared"})

    # Hashing kicks off via share.refresh asynchronously; retry until share.list shows non-zero.
    def share_indexed(_):
        rpc(uploader, "share.refresh", {})
        r = rpc(uploader, "share.list", {"separator": "|"})
        return "B|" in (r or "") and "|0 B|" not in r
    retry(share_indexed, timeout_seconds=60)

    for c in [uploader, downloader]:
        rpc(c, "hub.add", {"huburl": HUB})

    # Pull uploader's filelist via the hub (peer-to-peer transfer brokered by CTM).
    # The filelist is itself a file shipped uploader -> downloader
    # performs full e2e: uhub ADC routing + eiskaltdcpp transfer + on-disk artifact.
    rpc(downloader, "list.download", {"huburl": HUB, "nick": "up"})
    downloader.wait_until_succeeds("ls /var/lib/dcpp/cfg/FileLists/*up*", timeout=60)
    fl = downloader.succeed("basename /var/lib/dcpp/cfg/FileLists/*up*").strip()
    rpc(downloader, "list.open", {"filelist": fl})

    # list.lsdir reports the shared dir with byte count parsed from the transferred filelist
    # matching the 18-byte upload.
    def listing_loaded(_):
        r = rpc(downloader, "list.lsdir", {"directory": "", "filelist": fl})
        return isinstance(r, dict) and r.get("shared", {}).get("Size") == "18"
    retry(listing_loaded, timeout_seconds=30)
  '';
}
