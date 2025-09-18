{
  lib,
  stdenv,
  fetchFromGitHub,
  pidgin,
  pkg-config,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "purple-slack";
  version = "0-unstable-2025-07-27";

  src = fetchFromGitHub {
    owner = "dylex";
    repo = "slack-libpurple";
    rev = "1115ec117bcddb38ee0ec649f139d04ab3b53942";
    hash = "sha256-4UzWcUpf99rvwLXHEVBagzdR0++GQQ/1mJ4V2TJPAHw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pidgin ];

  PKG_CONFIG_PURPLE_PLUGINDIR = "${placeholder "out"}/lib/purple-2";
  PKG_CONFIG_PURPLE_DATAROOTDIR = "${placeholder "out"}/share";

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    homepage = "https://github.com/dylex/slack-libpurple";
    description = "Slack plugin for Pidgin";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ eyjhb ];
  };
}
