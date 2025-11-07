{ lib, pkgs, ... }:
{
  name = "lighttpd";
  meta.maintainers = with lib.maintainers; [ bjornfor ];

  nodes = {
    server = {
      services.lighttpd.enable = true;
      services.lighttpd.document-root = pkgs.runCommand "document-root" { } ''
        mkdir -p "$out"
        echo "hello nixos test" > "$out/file.txt"
      '';
    };
  };

  testScript = ''
    start_all()
    server.wait_for_unit("lighttpd.service")
    res = server.succeed("curl --fail http://localhost/file.txt")
    assert "hello nixos test" in res, f"bad server response: '{res}'"
    server.succeed("systemctl reload lighttpd")
  '';
}
