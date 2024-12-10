import ./make-test-python.nix (
  { lib, ... }:

  let
    port = toString 4321;
  in
  {
    name = "mpv";
    meta.maintainers = with lib.maintainers; [ zopieux ];

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.curl
          (pkgs.wrapMpv pkgs.mpv-unwrapped {
            scripts = [ pkgs.mpvScripts.simple-mpv-webui ];
          })
        ];
      };

    testScript = ''
      machine.execute("set -m; mpv --script-opts=webui-port=${port} --idle=yes >&2 &")
      machine.wait_for_open_port(${port})
      assert "<title>simple-mpv-webui" in machine.succeed("curl -s localhost:${port}")
    '';
  }
)
