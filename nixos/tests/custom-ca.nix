# Checks that `security.pki` options are working in curl and the main browser
# engines: Gecko (via Firefox), Chromium, QtWebEngine (via qutebrowser) and
# WebKitGTK (via Midori). The test checks that certificates issued by a custom
# trusted CA are accepted but those from an unknown CA are rejected.

{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  inherit (pkgs) lib;

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

  webserverConfig =
    { networking.hosts."127.0.0.1" = [ "good.example.com" "bad.example.com" ];
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
    };

  curlTest = makeTest {
    name = "custom-ca-curl";
    meta.maintainers = with lib.maintainers; [ rnhmjoj ];
    nodes.machine = { ... }: webserverConfig;
    testScript = ''
        with subtest("Good certificate is trusted in curl"):
            machine.wait_for_unit("nginx")
            machine.wait_for_open_port(443)
            machine.succeed("curl -fv https://good.example.com")

        with subtest("Unknown CA is untrusted in curl"):
            machine.fail("curl -fv https://bad.example.com")
    '';
  };

  mkBrowserTest = browser: testParams: makeTest {
    name = "custom-ca-${browser}";
    meta.maintainers = with lib.maintainers; [ rnhmjoj ];

    enableOCR = true;

    nodes.machine = { pkgs, ... }:
      { imports =
          [ ./common/user-account.nix
            ./common/x11.nix
            webserverConfig
          ];

        # chromium-based browsers refuse to run as root
        test-support.displayManager.auto.user = "alice";

        # browsers may hang with the default memory
        virtualisation.memorySize = 600;

        environment.systemPackages = [ pkgs.xdotool pkgs.${browser} ];
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
      machine.wait_for_x()

      command = "${browser} ${testParams.args or ""}"
      with subtest("Good certificate is trusted in ${browser}"):
          execute_as(
              "alice", f"{command} https://good.example.com >&2 &"
          )
          wait_for_window_as("alice", "${browser}")
          machine.sleep(4)
          execute_as("alice", "xdotool key ctrl+r")  # reload to be safe
          machine.wait_for_text("It works!")
          machine.screenshot("good${browser}")
          execute_as("alice", "xdotool key ctrl+w")  # close tab

      with subtest("Unknown CA is untrusted in ${browser}"):
          execute_as("alice", f"{command} https://bad.example.com >&2 &")
          machine.wait_for_text("${testParams.error}")
          machine.screenshot("bad${browser}")
    '';
  };

in

{
  curl = curlTest;
} // pkgs.lib.mapAttrs mkBrowserTest {
  firefox = { error = "Security Risk"; };
  chromium = { error = "not private"; };
  qutebrowser = { args = "-T"; error = "Certificate error"; };
  midori = { args = "-p"; error = "Security"; };
}
