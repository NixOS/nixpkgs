{
  lib,
  chatterino2,
  fetchFromGitHub,
  nix-update-script,
  boost186,
}:

(chatterino2.buildChatterino {
  enableAvifSupport = true;
  boost = boost186;
}).overrideAttrs
  (
    finalAttrs: _: {
      pname = "chatterino7";
      version = "7.5.2";

      src = fetchFromGitHub {
        owner = "SevenTV";
        repo = "chatterino7";
        tag = "v${finalAttrs.version}";
        hash = "sha256-kQeW9Qa8NPs47xUlqggS4Df4fxIoknG8O5IBdOeIo+4=";
        fetchSubmodules = true;
      };

      passthru.updateScript = nix-update-script { };

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
        maintainers = with lib.maintainers; [ marie ];
      };
    }
  )
