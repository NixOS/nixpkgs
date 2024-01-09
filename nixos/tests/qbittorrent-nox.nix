import ./make-test-python.nix ({ pkgs, ...} : {
  name = "qbittorrent-nox";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ camilosampedro ];
  };

  nodes = {
    simple = {
      services.qbittorrent-nox = {
        enable = true;
        package = pkgs.qbittorrent-nox;
        port = 8091;
        web = {
          enable = true;
          openFirewall = true;
        };
      };
    };

  };

  testScript = ''
    start_all()

    simple.wait_for_unit("qbittorrent-nox")
    simple.wait_for_open_port(8091)
    simple.wait_until_succeeds("curl --fail http://simple:8091")
  '';
})
