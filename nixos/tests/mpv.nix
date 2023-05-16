import ./make-test-python.nix ({ lib, ... }:

<<<<<<< HEAD
=======
with lib;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
let
  port = toString 4321;
in
{
  name = "mpv";
<<<<<<< HEAD
  meta.maintainers = with lib.maintainers; [ zopieux ];
=======
  meta.maintainers = with maintainers; [ zopieux ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
})
