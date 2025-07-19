{
  lib,
  chatterino2,
  fetchFromGitHub,
  gitUpdater,
}:

(chatterino2.buildChatterino {
  enableAvifSupport = true;
}).overrideAttrs
  (
    finalAttrs: _: {
      pname = "chatterino7";
      version = "7.5.3";

      src = fetchFromGitHub {
        owner = "SevenTV";
        repo = "chatterino7";
        tag = "v${finalAttrs.version}";
        hash = "sha256-KrAr3DcQDjb+LP+vIf0qLSSgII0m5rNwhncLNHlLaC8=";
        fetchSubmodules = true;
      };

      passthru.updateScript = gitUpdater {
        rev-prefix = "v";
        ignoredVersions = "beta";
      };

      meta = {
        description = "Chat client for Twitch chat";
        mainProgram = "chatterino";
        longDescription = ''
          Chatterino is a chat client for Twitch chat. It aims to be an
          improved/extended version of the Twitch web chat. Chatterino 7 is
          a fork of Chatterino 2, which contains additional 7TV features
          not found in Chatterino 2.
        '';
        homepage = "https://github.com/SevenTV/chatterino7";
        changelog = "https://github.com/SevenTV/chatterino7/blob/${finalAttrs.src.rev}/CHANGELOG.c7.md";
        license = lib.licenses.mit;
        platforms = lib.platforms.unix;
        maintainers = with lib.maintainers; [
          marie
          supa
        ];
      };
    }
  )
