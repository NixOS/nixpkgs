{
  telegram-desktop,
  lib,
  fetchFromGitHub,
}:
telegram-desktop.overrideAttrs (
  finalAttrs: previousAttrs: {
    pname = "materialgram";
    version = "5.5.4.1";

    src = fetchFromGitHub {
      owner = "kukuruzka165";
      repo = "materialgram";
      rev = "refs/tags/v${finalAttrs.version}";
      fetchSubmodules = true;
      hash = "sha256-LfeIhnCQ/b3Z7F3jUEdutlbZjSQoGr+zXP3oBiqe3XY=";
    };

    meta = previousAttrs.meta // {
      description = "Telegram Desktop fork with material icons and some improvements";
      longDescription = ''
        Telegram Desktop fork with Material Design and other improvements,
        which is based on the Telegram API and the MTProto secure protocol.
      '';
      homepage = "https://kukuruzka165.github.io/materialgram/";
      changelog = "https://github.com/kukuruzka165/materialgram/releases/tag/v${finalAttrs.version}";
      maintainers = with lib.maintainers; [
        oluceps
        aleksana
      ];
      mainProgram = "materialgram";
    };
  }
)
