{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "matterbridge";
  version = "1.26.0-unstable-2024-08-27";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterbridge";
    rev = "c4157a4d5b49fce79c80a30730dc7c404bacd663";
    hash = "sha256-ZnNVDlrkZd/I0NWmQMZzJ3RIruH0ARoVKJ4EyYVdMiw=";
  };

  subPackages = [ "." ];

  vendorHash = null;

  meta = {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = "https://github.com/42wim/matterbridge";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ ryantm ];
    mainProgram = "matterbridge";
  };
}
