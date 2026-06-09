{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nomsteams ? true, # msteams uses a lot of RAM (3GB) while building, without msteams 0,5GB
  nozulip ? false
}:

buildGoModule {
  pname = "matterbridge";
  version = "unstable-2026-06-05-5000072";

  src = fetchFromGitHub {
    owner = "matterbridge-org";
    repo = "matterbridge";
    rev = "50000724391eec1cf368ba615ee8973dede97a98";
    hash = "sha256-fgYbHKQytC7Lq6ksHTN7pnqTJF1Rb0D1DB7BCjkjdXw=";
  };

  subPackages = [ "." ];

  tags = [ "goolm" ] ++ lib.optionals nomsteams [ "nomsteams" ] ++ lib.optionals nozulip [ "nozulip" ];

  vendorHash = "sha256-NsR2Np5QOXiwBsQ7tydU18eC789kpIAkYpMHmrQNmaI=";

  meta = {
    description = "Multi-protocol chat bridge (IRC, Matrix, XMPP, Discord, Telegram, etc…) for Mattermost";
    homepage = "https://github.com/matterbridge-org/matterbridge";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ymarkus ];
    mainProgram = "matterbridge";
  };