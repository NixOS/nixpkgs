{ stdenv, fetchFromGitHub, lib, git,
  pidgin, glib, json-glib,
  # markdown implementation
  discount
}:

stdenv.mkDerivation rec {
  pname = "purple-mattermost";
  version = "v2.1";
  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = pname;
    rev = version;
    leaveDotGit = true;
    sha256 = "sha256-/lFGr6s4R/LQ2N60b6lJwQjjIoZxZTiKupmHV1APl9A=";
  };

  PKG_CONFIG_PURPLE_PLUGINDIR = "${placeholder "out"}/lib/purple-2";
  PKG_CONFIG_PURPLE_DATAROOTDIR = "${placeholder "out"}/share";

  nativeBuildInputs = [
    git
    glib
    json-glib
    discount
    pidgin
  ];

  meta = with lib; {
    homepage = "https://github.com/EionRobb/purple-mattermost";
    description = "Plugin for Pidgin which adds support for Mattermost";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ danielsiepmann ];
  };
}
