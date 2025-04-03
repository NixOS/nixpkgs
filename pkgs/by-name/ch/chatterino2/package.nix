{
  lib,
  callPackage,
  fetchFromGitHub,
  nix-update-script,
  boost186,
}:

(callPackage ./common.nix {
  boost = boost186;
}).overrideAttrs
  (
    finalAttrs: _: {
      pname = "chatterino2";
      version = "2.5.2";

      src = fetchFromGitHub {
        owner = "Chatterino";
        repo = "chatterino2";
        tag = "v${finalAttrs.version}";
        hash = "sha256-nrw4dQ7QjPPMbZXMC+p3VgUQKwc1ih6qS13D9+9oNuw=";
        fetchSubmodules = true;
      };

      passthru = {
        buildChatterino = args: callPackage ./common.nix args;
        updateScript = nix-update-script { };
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
