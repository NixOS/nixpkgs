{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "bypass.yazi";
  version = "0-unstable-2025-04-09";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "bypass.yazi";
    rev = "2ab6d84e8165985dd4d63ef0098e3a30feb3a41a";
    hash = "sha256-6LiBUvHmN8q/ao1+QhCg75ypuf1i6MyRQiU16Lb8pEs=";
  };

  meta = {
    description = "Yazi plugin for skipping directories with only a single sub-directory.";
    homepage = "https://github.com/Rolv-Apneseth/bypass.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
