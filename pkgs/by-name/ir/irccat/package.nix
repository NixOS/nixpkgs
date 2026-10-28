{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "irccat";
  version = "0.4.13";

  src = fetchFromGitHub {
    owner = "irccloud";
    repo = "irccat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mc5ccJnnDKTZr4GHI6YUOEr8Rwtkw1rrpL4gwOlLyb0=";
  };

  vendorHash = "sha256-SUE868jVJywqE0A5yjMWohrMw58OUnxGGxvcR8UzPfE=";

  meta = {
    homepage = "https://github.com/irccloud/irccat";
    changelog = "https://github.com/irccloud/irccat/releases/tag/v${finalAttrs.version}";
    description = "Send events to IRC channels from scripts and other applications";
    mainProgram = "irccat";
    maintainers = with lib.maintainers; [ qyliss ];
    license = lib.licenses.gpl3Only;
  };
})
