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

  src = fetchFromGitHub {
    owner = "simons-public";
    repo = "cecdaemon";
    rev = "ac6d1d9edeca4a79dfdfdad1edc8976f3f14c4dd";
    hash = "sha256-WGKtOvmWWqKbulCA8hSmNoL/NwJqE6VW8JbcOiKWG04=";
  };

  patches = [
    (fetchpatch {
      name = "Fix confusing logging message";
      url = "https://github.com/simons-public/cecdaemon/commit/7d6c889b33bd5f5a2b230d4634445acfa21c4969.diff";
      hash = "sha256-BzcviuNs4FUHdkkB5h4Ll48jxo1LwsukU8oxRl8+Syo=";
    })
    (fetchpatch {
      name = "Don't initialize `uinput` unless it's necessary";
      url = "https://github.com/simons-public/cecdaemon/commit/86374a6567d6ec88d801d2edab27467bb6089f79.diff";
      hash = "sha256-y/n8yFB/86G0HoTN5XPRWHdTsN6j2y/E+vpCczgnd80=";
    })
    (fetchpatch {
      name = "Fix a few bugs with config parsing";
      url = "https://github.com/simons-public/cecdaemon/commit/06c467827da0e50922be6de87440eee0540140ed.diff";
      hash = "sha256-knUZ9iNvkucEkOyvB14A4q5Ggv7KZkwmNMPc1lWt1Dw=";
    })
  ];

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
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
