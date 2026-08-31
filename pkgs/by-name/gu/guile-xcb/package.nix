{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  guile,
  pkg-config,
  texinfo,
}:

stdenv.mkDerivation {
  pname = "guile-xcb";
  version = "1.3-unstable-2017-05-28";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mwitmer";
    repo = "guile-xcb";
    rev = "db7d5a393cc37a56f66541b3f33938b40c6f35b3";
    hash = "sha256-zbIsEIPwNJ1YXMZTDw2DfzufC+IZWfcWgZHbuv7bhJs=";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail "2.0 2.2" "2.0 2.2 3.0"
  '';

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];
  buildInputs = [
    guile
  ];

  configureFlags = [
    "--with-guile-site-dir=$(out)/${guile.siteDir}"
    "--with-guile-site-ccache-dir=$(out)/${guile.siteCcacheDir}"
  ];

  makeFlags = [
    "GUILE_AUTO_COMPILE=0"
  ];

  meta = {
    homepage = "https://github.com/mwitmer/guile-xcb";
    description = "XCB bindings for Guile";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = guile.meta.platforms;
  };
}
