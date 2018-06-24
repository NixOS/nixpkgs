import ./make-test.nix ({ pkgs, ...} : {
  name = "transmission";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ coconnor ];
  };

  machine = { ... }: {
    imports = [ ../modules/profiles/minimal.nix ];

    networking.firewall.allowedTCPPorts = [ 9091 ];

    services.transmission = {
      enable = true;
      settings = {
        download-dir = "/srv/torrents/";
      };
    };
  };

  testScript = with pkgs;
    let
      torrentFile = ./transmission/debian-9.4.0-amd64-netinst.iso.torrent;
    in
    ''
      startAll;
      $machine->waitForUnit("transmission");

      # Perform a quick smoke-test to ensure transmission can access it's directories and config
      # Pardon the blasphemy ;)
      $machine->succeed("${transmission}/bin/transmission-remote -a ${torrentFile}");
      $machine->succeed("${transmission}/bin/transmission-remote -t all -S");

      $machine->shutdown;
    '';
})
