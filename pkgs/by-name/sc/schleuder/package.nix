{
  lib,
  bundlerApp,
  ruby,
  stdenv,
  bundlerUpdateScript,
  nixosTests,
}:

bundlerApp {
  inherit ruby;

  pname = "schleuder";

  gemdir = ./.;

  exes = [
    "schleuder"
    "schleuder-api-daemon"
  ];

  passthru.updateScript = bundlerUpdateScript "schleuder";
  passthru.tests = {
    inherit (nixosTests) schleuder;
  };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Encrypting mailing list manager with remailing-capabilities";
    longDescription = ''
      Schleuder is a group's email-gateway: subscribers can exchange
      encrypted emails among themselves, receive emails from
      non-subscribers and send emails to non-subscribers via the list.
    '';
    homepage = "https://schleuder.org";
    changelog = "https://0xacab.org/schleuder/schleuder/blob/main/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
  };
}
