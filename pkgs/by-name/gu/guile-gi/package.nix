{
  lib,
  stdenv,
  fetchurl,
  glib,
  gobject-introspection,
  guile,
  libffi,
  pkg-config,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-gi";
  version = "0.3.2";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/spk121/guile-gi/releases/download/v${finalAttrs.version}/guile_gi-${finalAttrs.version}.tar.gz";
    hash = "sha256-fjW5tmHjMaRbxE9OQJO3SGk8YD3pTXKAmKeo5x9cNQU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gobject-introspection
    guile
    pkg-config
    texinfo
  ];

  buildInputs = [
    glib
    gobject-introspection
    guile
    libffi
  ];

  configureFlags = [ "--with-gnu-filesystem-hierarchy" ];

  # GCC 14 turned these warnings into errors
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  enableParallelBuilding = true;

  doCheck = true;

  preCheck = ''
    # GLib 2.80 moved g_unix_fd_add_full into the GLibUnix namespace
    substituteInPlace test/main-loop.scm \
      --replace-fail '(load-by-name "GLib" "unix_fd_add_full")' \
        '(require "GLibUnix" "2.0") (load-by-name "GLibUnix" "fd_add_full")' \
      --replace-fail '(unix-fd-add-full' '(fd-add-full'
  ''
  # Darwin reports only HUP for a closed pipe with unread data
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace test/main-loop.scm \
      --replace-fail '(test-equal "unix-fd callback ran"' \
        '(test-skip "unix-fd callback ran") (test-equal "unix-fd callback ran"'
  ''
  + ''

    # Test sources from current gobject-introspection define a pointer
    # struct that this release cannot bind
    substituteInPlace Makefile \
      --replace-fail 'test/marshall.scm test/extra.scm' 'test/extra.scm'

    # Test typelibs expect their libraries next to them, not in .libs
    for lib in everything extra; do
      ln -s .libs/lib$lib-1.0.so.0 test/
    done
  '';

  meta = {
    description = "GObject bindings for Guile";
    homepage = "https://spk121.github.io/guile-gi/";
    changelog = "https://github.com/spk121/guile-gi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    inherit (guile.meta) platforms;
  };
})
