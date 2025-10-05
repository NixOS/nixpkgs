{
  lib,
  callPackage,
  fetchFromGitHub,
  gitUpdater,
  boost186,
}:

(callPackage ./common.nix {
  boost = boost186;
}).overrideAttrs
  (
    finalAttrs: _: {
      pname = "chatterino2";
      version = "2.5.4";

      src = fetchFromGitHub {
        owner = "Chatterino";
        repo = "chatterino2";
        tag = "v${finalAttrs.version}";
        hash = "sha256-eozT3Lfra4i+q3pCxH0Z1v/3Y/FB5yJc/88tA90hTzI=";
        fetchSubmodules = true;
        leaveDotGit = true;
        postFetch = ''
          git -C $out rev-parse --short HEAD > $out/GIT_HASH
          find "$out" -name .git -print0 | xargs -0 rm -rf
        '';
      };

      passthru = {
        buildChatterino = args: callPackage ./common.nix args;
        updateScript = gitUpdater {
          rev-prefix = "v";
          ignoredVersions = "beta";
        };
      };

      meta = {
        description = "Chat client for Twitch chat";
        mainProgram = "chatterino";
        longDescription = ''
          Chatterino is a chat client for Twitch chat. It aims to be an
          improved/extended version of the Twitch web chat. Chatterino 2 is
          the second installment of the Twitch chat client series
          "Chatterino".
        '';
        homepage = "https://github.com/Chatterino/chatterino2";
        changelog = "https://github.com/Chatterino/chatterino2/blob/${finalAttrs.src.rev}/CHANGELOG.md";
        license = lib.licenses.mit;
        platforms = lib.platforms.unix;
        maintainers = with lib.maintainers; [
          supa
          marie
        ];
      };
    }
  )
