{
  lib,
  python3Packages,
  fetchFromGitea,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "send-lxmf";
  version = "0-unstable-2026-05-15";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "melsner";
    repo = "send-lxmf";
    rev = "c8b28d5390d7ac334e48d5fe9fd16a864ae73abe";
    hash = "sha256-bTBYHU4gbm9W1t93Ig5SiTFcMwa+J33cf4RsRZbclaA=";
  };

  patches = [
    # Don't use a static directory in `/var/lib/send-lxmf`,
    # as this is not writable for unpriviledged users and thus prevents the
    # program from running without additional configuration.
    # This patch allow the user to specify environment variables to configure
    # the directories used for storing the program's state, and falls back to a
    # directory in the user's home directory if the environment variables are
    # not set.
    # The environment variables are XDG_STATE_HOME and XDG_CONFIG_HOME.
    ./env-vars.patch
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    rns
    filelock
    lxmf
    markdownify
  ];

  optional-dependencies = with python3Packages; {
    dev = [
      pytest
    ];
    integration = [
      pytest
      requests
    ];
  };

  pythonImportsCheck = [
    "send_lxmf"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Send LXMF messages over the Reticulum network from the command line";
    homepage = "https://codeberg.org/melsner/send-lxmf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "send-lxmf";
  };
})
