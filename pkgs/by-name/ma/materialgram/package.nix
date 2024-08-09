{
  telegram-desktop,
  lib,
  fetchFromGitHub,
}:
telegram-desktop.overrideAttrs (
  finalAttrs: previousAttrs: {
    pname = "materialgram";
    version = "5.2.1.1";

    src = fetchFromGitHub {
      owner = "kukuruzka165";
      repo = "materialgram";
      rev = "v${finalAttrs.version}";
      fetchSubmodules = true;
      hash = "sha256-tofpm5oz4E7UaGw1rD39UF0c22sxhazLm9ZvKX0vHSk=";
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
