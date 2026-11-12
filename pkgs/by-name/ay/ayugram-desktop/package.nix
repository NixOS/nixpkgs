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
      version = "7.2.9";

      src = fetchFromGitHub {
        owner = "AyuGram";
        repo = "AyuGramDesktop";
        tag = "v${finalAttrs.version}";
        hash = "sha256-JlZWJ+fWdJqgDMpPFLfkfFp/O65eQaA8GQD6ZY/SI/k=";
        fetchSubmodules = true;
      };

      # Find the Swift SDK overlays needed by the translation provider.
      # Remove after next release
      env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-L/usr/lib/swift";

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
