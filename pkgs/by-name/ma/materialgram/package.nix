{
  lib,
  telegram-desktop,
  fetchFromGitHub,
  withWebkit ? true,
}:

telegram-desktop.override {
  pname = "materialgram";
  inherit withWebkit;
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (
    finalAttrs: previousAttrs: {
      pname = "materialgram-unwrapped";
      version = "6.2.3.1";

      src = fetchFromGitHub {
        owner = "kukuruzka165";
        repo = "materialgram";
        hash = "sha256-wWg45n6Da/f2j3rT8PNNEN5uuX8rMzZNbHAA2wL8NLA=";
        tag = "v${finalAttrs.version}";
        fetchSubmodules = true;
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
          stellessia
        ];
        mainProgram = "materialgram";
      };
    }
  );
}
