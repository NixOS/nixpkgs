import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    inherit (pkgs) writeTextDir python3 curl;
    webroot = writeTextDir "index.html" "<h1>Hi</h1>";
  in
  {
    name = "podman-dnsname";
    meta = {
      maintainers = with lib.maintainers; [ roberth ] ++ lib.teams.podman.members;
    };

    nodes = {
      podman = { pkgs, ... }: {
        virtualisation.podman.enable = true;
        virtualisation.podman.defaultNetwork.dnsname.enable = true;
      };
    };

    testScript = ''
      podman.wait_for_unit("sockets.target")

      with subtest("DNS works"): # also tests inter-container tcp routing
        podman.succeed("tar cvf scratchimg.tar --files-from /dev/null && podman import scratchimg.tar scratchimg")
        podman.succeed(
          "podman run -d --name=webserver -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin -w ${webroot} scratchimg ${python3}/bin/python -m http.server 8000"
        )
        podman.succeed("podman ps | grep webserver")
        podman.succeed("""
          for i in `seq 0 120`; do
            podman run --rm --name=client -v /nix/store:/nix/store -v /run/current-system/sw/bin:/bin scratchimg ${curl}/bin/curl http://webserver:8000 >/dev/console \
              && exit 0
            sleep 0.5
          done
          exit 1
        """)
        podman.succeed("podman stop webserver")
        podman.succeed("podman rm webserver")

    '';
  }
)
