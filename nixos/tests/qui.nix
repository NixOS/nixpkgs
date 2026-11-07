{ lib, ... }:
let
  inherit (lib) removePrefix;
in

{
  name = "qui";
  meta.maintainers = with lib.maintainers; [
    connor-grady
    undefined-landmark
  ];

  nodes.machine = {
    services.qui.enable = true;

    specialisation = {
      # Use port other than default to test if settings options work.
      settingsPort.configuration.services.qui.settings.port = 7777;

      # Use a session secret file to test if it propagates to the service.
      settingsSessionSecretFile.configuration =
        { config, ... }:
        let
          cfg = config.services.qui;
        in
        {
          # This secret lands in the Nix store (making it readable by everyone).
          # DO NOT DO THIS OUTSIDE OF TESTS!!
          environment.etc.${removePrefix "/etc/" cfg.settings.sessionSecretFile}.text = "not-secret";
          services.qui.settings.sessionSecretFile = "/etc/qui/session-secret";
        };
    };
  };

  testScript =
    { nodes, ... }:
    let
      inherit (nodes.machine.system.build) toplevel;
    in
    # python
    ''
      def switch_to_specialisation(s):
        machine.succeed(f'${toplevel}/specialisation/{s}/bin/switch-to-configuration test')

      def check(port=7476, session_secret=None):
        machine.wait_for_unit('qui.service')

        machine.wait_for_open_port(port)
        machine.wait_until_succeeds(f'curl --fail http://localhost:{port}')

        credential = '/run/credentials/qui.service/sessionSecretFile'
        if session_secret:
          machine.succeed(f'[ "$(cat {credential})" = "{session_secret}" ]')
        else:
          machine.fail(f'test -e {credential}')

      check()

      switch_to_specialisation('settingsPort')
      check(port=7777)

      switch_to_specialisation('settingsSessionSecretFile')
      check(session_secret='not-secret')
    '';
}
