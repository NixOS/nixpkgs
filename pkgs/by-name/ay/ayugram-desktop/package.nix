{
  lib,
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
      version = "7.0.9";

      src = fetchFromGitHub {
        owner = "AyuGram";
        repo = "AyuGramDesktop";
        # tag = "v${finalAttrs.version}";
        # v7.0.9 tag contains a codegen bug due to an outdated submodule
        # https://github.com/AyuGram/codegen/pull/3
        rev = "db3b9891cb0b04ebb7d8c0e71ada3bcc669b910a";
        hash = "sha256-JSx6qPpVul3NX8stNZzZX/ckNBQ3uXZP7lofb6eWauM=";
        fetchSubmodules = true;
      };

      passthru.updateScript = nix-update-script { };

      meta = previousAttrs.meta // {
        mainProgram = "AyuGram";
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
