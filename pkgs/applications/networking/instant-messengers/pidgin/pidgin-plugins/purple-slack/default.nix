{
  lib,
  stdenv,
  fetchFromGitHub,
  pidgin,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "purple-slack-unstable";
  version = "2020-09-22";

  src = fetchFromGitHub {
    owner = "dylex";
    repo = "slack-libpurple";
    rev = "2e9fa028224b02e29473b1b998fc1e5f487e79ec";
    sha256 = "1sksqshiwldd32k8jmiflp2pcax31ym6rypr4qa4v5vdn907g80m";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pidgin ];

  PKG_CONFIG_PURPLE_PLUGINDIR = "${placeholder "out"}/lib/purple-2";
  PKG_CONFIG_PURPLE_DATAROOTDIR = "${placeholder "out"}/share";

  meta = with lib; {
    homepage = "https://github.com/dylex/slack-libpurple";
    description = "Slack plugin for Pidgin";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eyjhb ];
  };
}
