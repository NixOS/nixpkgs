{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "keychain";
  version = "3.0.4";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "danielrobbins";
    repo = "keychain";
    tag = finalAttrs.version;
    hash = "sha256-1cIrbMj+Y94PuDapZVk2buVolAKisaQghWdyPD5xCMQ=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  meta = {
    description = "Manage SSH and GPG keys in a convenient and secure manner";
    longDescription = ''
      Keychain helps you to manage SSH and GPG keys in a convenient and secure
      manner. It acts as a frontend to ssh-agent and ssh-add, but allows you
      to easily have one long running ssh-agent process per system, rather
      than the norm of one ssh-agent per login session.

      This dramatically reduces the number of times you need to enter your
      passphrase. With keychain, you only need to enter a passphrase once
      every time your local machine is rebooted. Keychain also makes it easy
      for remote cron jobs to securely "hook in" to a long-running ssh-agent
      process, allowing your scripts to take advantage of key-based logins.
    '';
    homepage = "https://kernel-seeds.org/projects/keychain/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sigma ];
    mainProgram = "keychain";
  };
})
