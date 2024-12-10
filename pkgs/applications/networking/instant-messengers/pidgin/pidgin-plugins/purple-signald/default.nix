{
  lib,
  stdenv,
  fetchFromGitHub,
  pidgin,
  json-glib,
  signald,
}:

stdenv.mkDerivation rec {
  pname = "purple-signald";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "hoehermann";
    repo = "libpurple-signald";
    rev = "v${version}";
    sha256 = "sha256-2LiHjVRBwdPbfravIVM+gvsh3Gq4bhjtRD6eWAbkWmc=";
    fetchSubmodules = true;
  };

  buildInputs = [
    pidgin
    json-glib
    signald
  ];

  PKG_CONFIG_PURPLE_PLUGINDIR = "${placeholder "out"}/lib/purple-2";
  PKG_CONFIG_PURPLE_DATADIR = "${placeholder "out"}/share";
  PKG_CONFIG_PIDGIN_DATADIR = "${placeholder "out"}/share";

  meta = with lib; {
    homepage = "https://github.com/hoehermann/libpurple-signald";
    description = "Signal support for Pidgin / libpurple";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hufman ];
  };
}
