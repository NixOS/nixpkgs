{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  libappindicator,
  mono,
  gtk-sharp-3_0,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "appindicator-sharp";
  version = "0-unstable-2016-01-18";

  src = fetchFromGitHub {
    owner = "sundermann";
    repo = "appindicator-sharp";
    rev = "5a79cde93da6d68a4b1373f1ce5796c3c5fe1b37";
    hash = "sha256-1HBmjw5lwdorOoXuWKxltwBNKnXnPp92cUnQAu7CG8Q=";
  };

  nativeBuildInputs = [
    autoreconfHook
    mono
    pkg-config
  ];

  buildInputs = [
    gtk-sharp-3_0
    libappindicator
  ];

  ac_cv_path_MDOC = "no";
  installFlags = [ "GAPIXMLDIR=/tmp/gapixml" ];

  meta = {
    description = "Bindings for appindicator using gobject-introspection";
    homepage = "https://github.com/sundermann/appindicator-sharp";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ kevincox ];
  };
}
