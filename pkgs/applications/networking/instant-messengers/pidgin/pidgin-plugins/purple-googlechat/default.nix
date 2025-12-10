{
  lib,
  stdenv,
  fetchFromGitHub,
  pidgin,
  glib,
  json-glib,
  protobuf,
  protobufc,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "purple-googlechat";
  version = "0-unstable-2025-09-09";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "purple-googlechat";
    rev = "653a6dde34e0f3e556ffb3b86c23d535f9a27d11";
    hash = "sha256-7gi1lcog68Hdcm3qV2Wj+1K7grcusoi44hEwme0o26w=";
  };

  nativeBuildInputs = [ protobufc ];
  buildInputs = [
    pidgin
    glib
    json-glib
    protobuf
  ];

  PKG_CONFIG_PURPLE_PLUGINDIR = "${placeholder "out"}/lib/purple-2";
  PKG_CONFIG_PURPLE_DATADIR = "${placeholder "out"}/share";

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    homepage = "https://github.com/EionRobb/purple-googlechat";
    description = "Native Google Chat support for pidgin";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
