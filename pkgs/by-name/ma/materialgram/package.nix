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
      version = "5.9.0.1";

      src = fetchFromGitHub {
        owner = "kukuruzka165";
        repo = "materialgram";
        rev = "refs/tags/v${finalAttrs.version}";
        hash = "sha256-QmXwO8Dn+ATWGwN5smxOB2kxmJZETSMbqwFoR0t3luc=";
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
