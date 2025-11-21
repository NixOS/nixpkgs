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
      version = "7.5.4";

      src = fetchFromGitHub {
        owner = "SevenTV";
        repo = "chatterino7";
        tag = "v${finalAttrs.version}";
        hash = "sha256-zA198AIFIRx4qE5MZwrGOFFrpnVrZMVQx1SX0RJpDo4=";
        fetchSubmodules = true;
        leaveDotGit = true;
        postFetch = ''
          git -C $out rev-parse --short HEAD > $out/GIT_HASH
          find "$out" -name .git -print0 | xargs -0 rm -rf
        '';
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
