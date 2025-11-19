{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "streamlabels";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "teken";
    repo = "streamlabels";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FAu00SucWHMQbhp9mJYIdPWtbiny09LABYkeZdV10GQ=";
  };

  vendorHash = "sha256-eZQe8gstzj9BxjuZiXV1UFnuzjICJBFjiTpJNGFiyFI=";

  meta = {
    description = "A small go app to get basic stream labels for twitch";
    longDescription = ''
      A simple Go program to generate text files containing Twitch stream information like newest followers, subscribers, and bits leaderboard.
      These files can then be used as sources in OBS Studio or other streaming software.
    '';
    homepage = "https://github.com/teken/streamlabels";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      teken
    ];
  };
})
