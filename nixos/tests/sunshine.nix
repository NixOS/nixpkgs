import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "sunshine";
  meta = {
    # test is flaky on aarch64
    broken = pkgs.stdenv.isAarch64;
    maintainers = [ lib.maintainers.devusb ];
  };

  nodes.sunshine = { config, pkgs, ... }: {
    imports = [
      ./common/x11.nix
    ];

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

  nodes.moonlight = { config, pkgs, ... }: {
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
    moonlight.wait_for_console_text("Executing request")

    # respond to pairing request from sunshine
    sunshine.succeed("curl --insecure -u sunshine:sunshine -d '{\"pin\": \"1234\"}' https://localhost:47990/api/pin")

    # close moonlight once pairing complete
    moonlight.send_key("kp_enter")

    # put words on the sunshine screen for moonlight to see
    sunshine.execute("gxmessage 'hello world' -center -font 'sans 75' >&2 & disown")

    # connect to sunshine from moonlight and look for the words
    moonlight.execute("moonlight --video-decoder software stream sunshine 'Desktop' >&2 & disown")
    moonlight.wait_for_text("hello world")
  '';
})
