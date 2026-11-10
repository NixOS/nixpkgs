{
  lib,
  telegram-desktop,
  fetchFromGitHub,
  fetchpatch2,
  withWebkit ? true,
}:

telegram-desktop.override {
  pname = "materialgram";
  inherit withWebkit;
  unwrapped = telegram-desktop.unwrapped.overrideAttrs (
    finalAttrs: previousAttrs: {
      pname = "materialgram-unwrapped";
      version = "7.3.1.1";

      src = fetchFromGitHub {
        owner = "kukuruzka165";
        repo = "materialgram";
        hash = "sha256-7ov8GtHTS8nUADwah8KEg9j88ksZ8Eb6SlZc3z83UaM=";
        tag = "v${finalAttrs.version}";
        fetchSubmodules = true;
      };

      patches = [
        # Fixed nixpkgs swift build missing runtime library paths
        (fetchpatch2 {
          url = "https://github.com/telegramdesktop/tdesktop/commit/e8a7ff26b34bc180c36a1a02b34a6c1d5878c3f5.patch?full_index=1";
          hash = "sha256-3XPbKeSGqsRZcCNzxRt0weMPtycOQdiZ8yRhIU8lgA0=";
        })
      ];

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
