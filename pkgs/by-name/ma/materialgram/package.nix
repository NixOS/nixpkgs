{
  telegram-desktop,
  lib,
  fetchFromGitHub,
}:
telegram-desktop.overrideAttrs (
  finalAttrs: previousAttrs: {
    pname = "materialgram";
    version = "5.7.0.1";

    src = fetchFromGitHub {
      owner = "kukuruzka165";
      repo = "materialgram";
      rev = "refs/tags/v${finalAttrs.version}";
      fetchSubmodules = true;
      hash = "sha256-YdLUwXMATla64KSYnXLXwLl0KktNoB/IuHIIY44R1VY=";
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
