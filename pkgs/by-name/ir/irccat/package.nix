{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "irccat";
  version = "0.4.12";

  src = fetchFromGitHub {
    owner = "irccloud";
    repo = "irccat";
    rev = "v${version}";
    hash = "sha256-W6Qj+zg6jC304bEIQeFB8unSFgjV60zXV+I8hpw3AFA=";
  };

  vendorHash = "sha256-SUE868jVJywqE0A5yjMWohrMw58OUnxGGxvcR8UzPfE=";

  meta = {
    homepage = "https://github.com/irccloud/irccat";
    changelog = "https://github.com/irccloud/irccat/releases/tag/v${version}0.4.11";
    description = "Send events to IRC channels from scripts and other applications";
    mainProgram = "irccat";
    maintainers = with lib.maintainers; [ qyliss ];
    license = lib.licenses.gpl3Only;
  };
}
