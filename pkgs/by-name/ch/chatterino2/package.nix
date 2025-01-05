{
  lib,
  callPackage,
  fetchFromGitHub,
  nix-update-script,
}:

(callPackage ./common.nix { }).overrideAttrs (finalAttrs: _: {
  pname = "chatterino2";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "Chatterino";
    repo = "chatterino2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c3Vhzes54xLjKV0Of7D1eFpQvIWJwcUBXvLT2p6VwBE=";
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
      rexim
      supa
      marie
    ];
  };
})
