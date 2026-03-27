{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  guile_2_2,
  pkg-config,
  texinfo,
}:

stdenv.mkDerivation {
  pname = "guile-xcb";
  version = "unstable-2017-05-29";

  src = fetchFromGitHub {
    owner = "mwitmer";
    repo = "guile-xcb";
    rev = "db7d5a393cc37a56f66541b3f33938b40c6f35b3";
    hash = "sha256-zbIsEIPwNJ1YXMZTDw2DfzufC+IZWfcWgZHbuv7bhJs=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    guile_2_2
    texinfo
  ];

  configureFlags = [
    "--with-guile-site-dir=$(out)/${guile_2_2.siteDir}"
    "--with-guile-site-ccache-dir=$(out)/${guile_2_2.siteCcacheDir}"
  ];

  makeFlags = [
    "GUILE_AUTO_COMPILE=0"
  ];

  meta = {
    homepage = "https://github.com/mwitmer/guile-xcb";
    description = "XCB bindings for Guile";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = guile_2_2.meta.platforms;
  };
}
