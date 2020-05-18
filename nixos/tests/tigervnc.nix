{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  makeVNCTest = name: vncPackage: (import ./make-test-python.nix ({
    inherit name;
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ iblech ];
    };

    nodes = {
      server = { pkgs, ...}: {
        environment.systemPackages = [ vncPackage pkgs.xorg.xwininfo pkgs.xteddy ];
        networking.firewall.allowedTCPPorts = [ 5901 ];
      };

      client = { pkgs, ... }: {
        imports = [ ./common/x11.nix ];
        environment.systemPackages = [ vncPackage ];
      };
    };

    testScript = ''
      start_all()

      for host in [server, client]:
          host.succeed("mkdir /root/.vnc")
          host.succeed("echo foobar | vncpasswd -f > /root/.vnc/passwd")

      server.succeed("vncserver -geometry 1234x567 :1")
      server.succeed("DISPLAY=:1 xwininfo -root | grep 1234x567")
      server.execute("DISPLAY=:1 xteddy &")

      client.wait_for_x()
      client.execute("vncviewer server:1 &")
      client.wait_for_window(r"VNC")
      client.screenshot("screenshot")

      server.succeed("vncserver -kill :1")
    '';
  }) { inherit system; });

in with pkgs; {
  testTigerVNC = makeVNCTest "tigervnc" tigervnc;
  testTightVNC = makeVNCTest "tightvnc" tightvnc;
}
