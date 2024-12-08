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

stdenv.mkDerivation rec {
  pname = "appindicator-sharp";
  version = "5a79cde93da6d68a4b1373f1ce5796c3c5fe1b37";

  src = fetchFromGitHub {
    owner = "stsundermann";
    repo = "appindicator-sharp";
    rev = version;
    sha256 = "sha256:1i0vqbp05l29f5v9ygp7flm4s05pcnn5ivl578mxmhb51s7ncw6l";
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
  installFlags = ["GAPIXMLDIR=/tmp/gapixml"];

  meta = {
    description = "Bindings for appindicator using gobject-introspection";
    homepage = "https://github.com/stsundermann/appindicator-sharp";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ kevincox ];
  };
}
