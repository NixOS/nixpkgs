{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  telegram-desktop,
  withWebkit ? true,
}:

telegram-desktop.override {
  pname = "ayugram-desktop";
  inherit withWebkit;
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (
    finalAttrs: previousAttrs: {
      pname = "ayugram-desktop-unwrapped";
      version = "5.12.3";

      src = fetchFromGitHub {
        owner = "AyuGram";
        repo = "AyuGramDesktop";
        tag = "v${finalAttrs.version}";
        hash = "sha256-Zjik+9J0YtabVW1VEkJr/Bl3SIakVQ8EiTLYm28rEIk=";
        fetchSubmodules = true;
      };

      passthru.updateScript = nix-update-script { };

      meta = previousAttrs.meta // {
        mainProgram = if stdenv.hostPlatform.isLinux then "ayugram-desktop" else "AyuGram";
        description = "Desktop Telegram client with good customization and Ghost mode";
        longDescription = ''
          The best that could be in the world of Telegram clients.
          AyuGram is a Telegram client with a very pleasant features.
        '';
        homepage = "https://github.com/AyuGram/AyuGramDesktop";
        changelog = "https://github.com/AyuGram/AyuGramDesktop/releases/tag/v${finalAttrs.version}";
        maintainers = with lib.maintainers; [
          kaeeraa
          s0me1newithhand7s
        ];
      };
    }
  );
}
