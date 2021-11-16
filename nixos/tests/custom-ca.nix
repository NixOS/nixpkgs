# Checks that `security.pki` options are working in curl and the main browser
# engines: Gecko (via Firefox), Chromium, QtWebEngine (Falkon) and WebKitGTK
# (via Midori). The test checks that certificates issued by a custom trusted
# CA are accepted but those from an unknown CA are rejected.

import ./make-test-python.nix ({ pkgs, lib, ... }:

let
  makeCert = { caName, domain }: pkgs.runCommand "example-cert"
  { buildInputs = [ pkgs.gnutls ]; }
  ''
    mkdir $out

    # CA cert template
    cat >ca.template <<EOF
    organization = "${caName}"
    cn = "${caName}"
    expiration_days = 365
    ca
    cert_signing_key
    crl_signing_key
    EOF

    # server cert template
    cat >server.template <<EOF
    organization = "An example company"
    cn = "${domain}"
    expiration_days = 30
    dns_name = "${domain}"
    encryption_key
    signing_key
    EOF

    # generate CA keypair
    certtool                \
      --generate-privkey    \
      --key-type rsa        \
      --sec-param High      \
      --outfile $out/ca.key
    certtool                     \
      --generate-self-signed     \
      --load-privkey $out/ca.key \
      --template ca.template     \
      --outfile $out/ca.crt

    # generate server keypair
    certtool                    \
      --generate-privkey        \
      --key-type rsa            \
      --sec-param High          \
      --outfile $out/server.key
    certtool                            \
      --generate-certificate            \
      --load-privkey $out/server.key    \
      --load-ca-privkey $out/ca.key     \
      --load-ca-certificate $out/ca.crt \
      --template server.template        \
      --outfile $out/server.crt
  '';

  example-good-cert = makeCert
    { caName = "Example good CA";
      domain = "good.example.com";
    };

  example-bad-cert = makeCert
    { caName = "Unknown CA";
      domain = "bad.example.com";
    };

in

{
  name = "custom-ca";
  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

  enableOCR = true;

  machine = { pkgs, ... }:
    { imports = [ ./common/user-account.nix ./common/x11.nix ];

      # chromium-based browsers refuse to run as root
      test-support.displayManager.auto.user = "alice";
      # browsers may hang with the default memory
      virtualisation.memorySize = 500;

      networking.hosts."127.0.0.1" = [ "good.example.com" "bad.example.com" ];
      security.pki.certificateFiles = [ "${example-good-cert}/ca.crt" ];

      services.nginx.enable = true;
      services.nginx.virtualHosts."good.example.com" =
        { onlySSL = true;
          sslCertificate = "${example-good-cert}/server.crt";
          sslCertificateKey = "${example-good-cert}/server.key";
          locations."/".extraConfig = ''
            add_header Content-Type text/plain;
            return 200 'It works!';
          '';
        };
      services.nginx.virtualHosts."bad.example.com" =
        { onlySSL = true;
          sslCertificate = "${example-bad-cert}/server.crt";
          sslCertificateKey = "${example-bad-cert}/server.key";
          locations."/".extraConfig = ''
            add_header Content-Type text/plain;
            return 200 'It does not work!';
          '';
        };

      environment.systemPackages = with pkgs; [
        xdotool
        firefox
        chromium
        qutebrowser
        midori
      ];
    };

  testScript = ''
    from typing import Tuple
    def execute_as(user: str, cmd: str) -> Tuple[int, str]:
        """
        Run a shell command as a specific user.
        """
        return machine.execute(f"sudo -u {user} {cmd}")


    def wait_for_window_as(user: str, cls: str) -> None:
        """
        Wait until a X11 window of a given user appears.
        """

        def window_is_visible(last_try: bool) -> bool:
            ret, stdout = execute_as(user, f"xdotool search --onlyvisible --class {cls}")
            if last_try:
                machine.log(f"Last chance to match {cls} on the window list")
            return ret == 0

        with machine.nested("Waiting for a window to appear"):
            retry(window_is_visible)


    machine.start()

    with subtest("Good certificate is trusted in curl"):
        machine.wait_for_unit("nginx")
        machine.wait_for_open_port(443)
        machine.succeed("curl -fv https://good.example.com")

    with subtest("Unknown CA is untrusted in curl"):
        machine.fail("curl -fv https://bad.example.com")

    browsers = {
      "firefox": "Security Risk",
      "chromium": "not private",
      "qutebrowser -T": "Certificate error",
      "midori": "Security"
    }

    machine.wait_for_x()
    for command, error in browsers.items():
        browser = command.split()[0]
        with subtest("Good certificate is trusted in " + browser):
            execute_as(
                "alice", f"env P11_KIT_DEBUG=trust {command} https://good.example.com & >&2"
            )
            wait_for_window_as("alice", browser)
            machine.wait_for_text("It works!")
            machine.screenshot("good" + browser)
            execute_as("alice", "xdotool key ctrl+w")  # close tab

        with subtest("Unknown CA is untrusted in " + browser):
            execute_as("alice", f"{command} https://bad.example.com & >&2")
            machine.wait_for_text(error)
            machine.screenshot("bad" + browser)
            machine.succeed("pkill " + browser)
  '';
})
