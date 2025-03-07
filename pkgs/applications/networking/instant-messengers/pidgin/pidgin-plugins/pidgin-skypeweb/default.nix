{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  pidgin,
  json-glib,
}:

stdenv.mkDerivation rec {
  pname = "pidgin-skypeweb";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "EionRobb";
    repo = "skype4pidgin";
    rev = version;
    sha256 = "11snyrjhm58gjvdmr5h5ajii3ah4a7c8zw3cavjv9xnnwrpfm5rb";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */skypeweb)
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pidgin
    json-glib
  ];

  PKG_CONFIG_PURPLE_PLUGINDIR = "${placeholder "out"}/lib/purple-2";
  PKG_CONFIG_PURPLE_DATADIR = "${placeholder "out"}/share";

  meta = with lib; {
    homepage = "https://github.com/EionRobb/skype4pidgin";
    description = "SkypeWeb plugin for Pidgin";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
