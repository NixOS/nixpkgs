{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
makeTest {
  name = "tigervnc";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ];
  };

  nodes = {
    server = { pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        tigervnc # for Xvnc
        xorg.xwininfo
        imagemagickBig # for display with working label: support
      ];
      networking.firewall.allowedTCPPorts = [ 5901 ];
    };

    client = { pkgs, ... }: {
      imports = [ ./common/x11.nix ];
      # for vncviewer
      environment.systemPackages = [ pkgs.tigervnc ];
    };
  };

  enableOCR = true;

  testScript = ''
    start_all()

    for host in [server, client]:
        host.succeed("echo foobar | vncpasswd -f > vncpasswd")

    server.succeed("Xvnc -geometry 720x576 :1 -PasswordFile vncpasswd >&2 &")
    server.wait_until_succeeds("nc -z localhost 5901", timeout=10)
    server.succeed("DISPLAY=:1 xwininfo -root | grep 720x576")
    server.execute("DISPLAY=:1 display -size 360x200 -font sans -gravity south label:'HELLO VNC' >&2 &")

    client.wait_for_x()
    client.execute("vncviewer server:1 -PasswordFile vncpasswd >&2 &")
    client.wait_for_window(r"VNC")
    client.screenshot("screenshot")
    text = client.get_screen_text()

    # Displayed text
    assert 'HELLO VNC' in text
    # Client window title
    # get_screen_text can't get correct string from screenshot
    # assert 'TigerVNC' in text
  '';
}
