{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  nix-update-script,
  stdenvNoCC,
  telegram-desktop,
  withWebkit ? true,
}:

telegram-desktop.override {
  pname = "ayugram-desktop";
  inherit withWebkit;
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (
    finalAttrs: previousAttrs: {
      pname = "ayugram-desktop-unwrapped";
      version = "6.7.8";

      src = fetchFromGitHub {
        owner = "AyuGram";
        repo = "AyuGramDesktop";
        tag = "v${finalAttrs.version}";
        hash = "sha256-X0g/zl5pJE8S5rkk7o81LiDNClLEMDyHVxmdoO4X9DE=";
        fetchSubmodules = true;
      };

      patches =
        (previousAttrs.patches or [ ])
        ++ (lib.optional stdenvNoCC.hostPlatform.isDarwin (fetchpatch2 {
          url = "https://github.com/telegramdesktop/tdesktop/commit/923efd9e7ef8ff72d9b83973502e587682119e54.patch?full_index=1";
          hash = "sha256-XcmH9SSI3K2SsFjHDEMnKA6YOyWF1kRVJJAWP2/vdf8=";
        }));

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
