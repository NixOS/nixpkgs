{ lib, stdenv, fetchFromGitHub, pkg-config, pidgin, glib, json-glib, nss, nspr
, libsecret
} :

stdenv.mkDerivation rec {
  pname = "pidgin-opensteamworks";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "pidgin-opensteamworks";
    rev = version;
    sha256 = "sha256-VWsoyFG+Ro+Y6ngSTMQ7yBYf6awCMNOc6U0WqNeg/jU=";
  };

  sourceRoot = "${src.name}/steam-mobile";

  installFlags = [
    "PLUGIN_DIR_PURPLE=${placeholder "out"}/lib/purple-2"
    "DATA_ROOT_DIR_PURPLE=${placeholder "out"}/share"
  ];

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    pidgin glib json-glib nss nspr libsecret
  ];

  meta = with lib; {
    homepage = "https://github.com/EionRobb/pidgin-opensteamworks";
    description = "Plugin for Pidgin 2.x which implements Steam Friends/Steam IM compatibility";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arobyn ];
  };
}
