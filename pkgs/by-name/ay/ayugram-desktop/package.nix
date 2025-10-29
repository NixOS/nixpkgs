{
  lib,
  fetchpatch2,
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
      version = "5.16.3";

      src = fetchFromGitHub {
        owner = "AyuGram";
        repo = "AyuGramDesktop";
        rev = "aafdac6da465e6498e39e1b55566fc8fe2402843";
        hash = "sha256-GNFkGw/CxtbeoEMBjExNudBcKFwlfXee5VVnXa4wGko=";
        fetchSubmodules = true;
      };

      # fix build failure with Qt 6.10
      patches = fetchpatch2 {
        name = "fix-build-with-qt-610.patch";
        url = "https://github.com/desktop-app/cmake_helpers/commit/682f1b57.patch";
        hash = "sha256-DHwgxAEFc1byQkVvrPwyctQKvUsK/KQ/cnzRv6PQuTM=";
        stripLen = 1;
        extraPrefix = "cmake/";
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
