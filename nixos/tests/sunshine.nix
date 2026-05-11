{ pkgs, lib, ... }:
{
  name = "sunshine";
  meta = {
    # test is flaky on aarch64
    broken = pkgs.stdenv.hostPlatform.isAarch64;
    maintainers = [ lib.maintainers.devusb ];
    timeout = 600;
  };

  nodes.sunshine =
    { config, pkgs, ... }:
    {
      imports = [
        ./common/x11.nix
      ];

      virtualisation.memorySize = 4096;

      services.sunshine = {
        enable = true;
        openFirewall = true;
        settings = {
          capture = "x11";
          encoder = "software";
          output_name = 0;
        };
      };

      environment.systemPackages = with pkgs; [
        gxmessage
      ];

    };

  nodes.moonlight =
    { config, pkgs, ... }:
    {
      imports = [
        ./common/x11.nix
      ];

      environment.systemPackages = with pkgs; [
        moonlight-qt
      ];

    };

  enableOCR = true;

  testScript = ''
    # start the tests, wait for sunshine to be up
    start_all()
    sunshine.wait_for_open_port(48010,"localhost")

    # set the admin username/password, restart sunshine
    sunshine.execute("sunshine --creds sunshine sunshine")
    sunshine.systemctl("restart sunshine","root")
    sunshine.wait_for_open_port(48010,"localhost")

    # initiate pairing from moonlight
    moonlight.execute("moonlight pair sunshine --pin 1234 >&2 & disown")
    moonlight.wait_for_console_text("Executing request.*pair")

    # respond to pairing request from sunshine
    sunshine.succeed("curl --fail --insecure -u sunshine:sunshine -H 'Content-Type: application/json' -d '{\"pin\":\"1234\",\"name\":\"sunshine\"}' https://localhost:47990/api/pin")

    # wait until pairing is complete
    moonlight.wait_for_console_text("Executing request.*phrase=pairchallenge")

    # hide icewm panel
    sunshine.send_key("ctrl-alt-h")
    # put words on the sunshine screen for moonlight to see
    sunshine.execute("gxmessage ' ABC' -center -font 'consolas 100' -fg '#FFFFFF' -bg '#000000' -borderless -geometry '2000x2000' -buttons \"\" >&2 & disown")

    # connect to sunshine from moonlight and look for the words
    moonlight.execute("moonlight --video-decoder software stream sunshine 'Desktop' >&2 & disown")
    moonlight.wait_for_console_text("Dropping window event during flush")
    moonlight.wait_for_text("ABC")
  '';
}
