import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "plausible";
  meta = with lib.maintainers; {
    maintainers = [ ];
  };

  nodes.machine = { pkgs, ... }: {
    virtualisation.memorySize = 4096;
    services.plausible = {
      enable = true;
      adminUser = {
        email = "admin@example.org";
        passwordFile = "${pkgs.writeText "pwd" "foobar"}";
        activate = true;
      };
      server = {
        baseUrl = "http://localhost:8000";
        secretKeybaseFile = "${pkgs.writeText "dont-try-this-at-home" "nannannannannannannannannannannannannannannannannannannan_batman!"}";
      };
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("plausible.service")
    machine.wait_for_open_port(8000)

    # Ensure that the software does not make not make the machine
    # listen on any public interfaces by default.
    machine.fail("ss -tlpn 'src = 0.0.0.0 or src = [::]' | grep LISTEN")

    machine.succeed("curl -f localhost:8000 >&2")

    machine.succeed("curl -f localhost:8000/js/script.js >&2")

    csrf_token = machine.succeed(
        "curl -c /tmp/cookies localhost:8000/login | grep '_csrf_token' | sed -E 's,.*value=\"(.*)\".*,\\1,g'"
    )

    machine.succeed(
        f"curl -b /tmp/cookies -f -X POST localhost:8000/login -F email=admin@example.org -F password=foobar -F _csrf_token={csrf_token.strip()} -D headers"
    )

    # By ensuring that the user is redirected to the dashboard after login, we
    # also make sure that the automatic verification of the module works.
    machine.succeed(
        "[[ $(grep 'location: ' headers | cut -d: -f2- | xargs echo) == /sites* ]]"
    )

    machine.shutdown()
  '';
})
