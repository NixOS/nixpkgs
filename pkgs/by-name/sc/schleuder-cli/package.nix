{
  lib,
  bundlerApp,
  ruby,
  bundlerUpdateScript,
}:

bundlerApp {
  inherit ruby;

  pname = "schleuder-cli";

  gemdir = ./.;

  installManpages = false;

  exes = [
    "schleuder-cli"
  ];

  passthru.updateScript = bundlerUpdateScript "schleuder-cli";

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Command line tool to create and manage schleuder-lists";
    longDescription = ''
      Schleuder-cli enables creating, configuring, and deleting lists,
      subscriptions, keys, etc. It uses the Schleuder API, provided by
      schleuder-api-daemon (part of Schleuder).
    '';
    homepage = "https://schleuder.org";
    changelog = "https://0xacab.org/schleuder/schleuder-cli/-/blob/main/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.gpl3Plus;
=======
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
