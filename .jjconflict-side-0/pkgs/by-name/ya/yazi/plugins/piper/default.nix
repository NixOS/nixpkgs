{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "piper.yazi";
  version = "0-unstable-2026-09-18";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "f703392df78b5fba5e8f9f1ad0b1cb6d3def9736";
    hash = "sha256-O1yYAhsf7xMqUrTTSLac06WSxCvUQqedH3DWqGwn/Ok=";
  };

  meta = {
    description = "Pipe any shell command as a previewer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
