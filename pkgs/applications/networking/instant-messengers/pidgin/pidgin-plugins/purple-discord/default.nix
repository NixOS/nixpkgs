{
  lib,
  stdenv,
  fetchFromGitHub,
  imagemagick,
  gettext,
  pidgin,
  json-glib,
  qrencode,
  nss,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "purple-discord";
  version = "0-unstable-2025-08-18";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "purple-discord";
    rev = "a04cdf4f7f74dea826110e3b8a83fa11fcd484f0";
    hash = "sha256-vCJnSvKgqmj0a5+vcGAJE5lVm+oYIUe+Xoo4SlPzxd8=";
  };

  nativeBuildInputs = [
    imagemagick
    gettext
  ];
  buildInputs = [
    pidgin
    json-glib
    qrencode
    nss
  ];

  PKG_CONFIG_PURPLE_PLUGINDIR = "${placeholder "out"}/lib/purple-2";
  PKG_CONFIG_PURPLE_DATADIR = "${placeholder "out"}/share";

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    homepage = "https://github.com/EionRobb/purple-discord";
    description = "Discord plugin for Pidgin";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sna ];
  };
}
