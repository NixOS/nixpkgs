{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
}:

python3.pkgs.buildPythonApplication {
  pname = "cecdaemon";
  version = "1.0.0-unstable-2025-11-12";
  pyproject = true;
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "simons-public";
    repo = "cecdaemon";
    rev = "ac6d1d9edeca4a79dfdfdad1edc8976f3f14c4dd";
    hash = "sha256-WGKtOvmWWqKbulCA8hSmNoL/NwJqE6VW8JbcOiKWG04=";
  };

  patches = [
    # https://github.com/simons-public/cecdaemon/pull/8
    ./patches/fix-confusing-logging-message.patch

    # https://github.com/simons-public/cecdaemon/pull/9
    ./patches/dont-initialize-uinput-unless-necessary.patch

    # https://github.com/simons-public/cecdaemon/pull/11
    ./patches/fix-a-few-bugs-with-config-parsing.patch
  ];

  build-system = [
    python3.pkgs.setuptools
  ];

  dependencies = with python3.pkgs; [
    cec
    python-uinput
    pyudev
  ];

  pythonImportsCheck = [
    "cecdaemon"
  ];

  meta = {
    description = "CEC Daemon for linux media centers";
    homepage = "https://github.com/simons-public/cecdaemon";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jfly ];
    mainProgram = "cecdaemon";
  };
}
