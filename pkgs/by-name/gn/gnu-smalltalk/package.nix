{
  config,
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libtool,
  zip,
  libffi,
  libsigsegv,
  readline,
  gmp,
  gnutls,
  gtk2,
  cairo,
  SDL,
  sqlite,
  emacsSupport ? config.emacsSupport or false,
  emacs ? null,
}:

assert emacsSupport -> (emacs != null);

let
  # The gnu-smalltalk project has a dependency to the libsigsegv library.
  # The project ships with sources for this library, but deprecated this option.
  # Using the vanilla libsigsegv library results in error: "cannot relocate [...]"
  # Adding --enable-static=libsigsegv to the gnu-smalltalk configuration flags
  # does not help, the error still occurs. The only solution is to build a
  # shared version of libsigsegv.
  libsigsegv-shared = lib.overrideDerivation libsigsegv (oldAttrs: {
    configureFlags = [ "--enable-shared" ];
  });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "gnu-smalltalk";
  version = "3.2.5";

  src = fetchurl {
    url = "mirror://gnu/smalltalk/smalltalk-${finalAttrs.version}.tar.xz";
    hash = "sha256-gZoV97qKG1X19gucmli63W9hU7P5h7cOexZ+d1XWWsw=";
  };

  patches = [
    # The awk script incorrectly parsed `glib/glib.h` and was trying to find `glib/gwin32.h`,
    # that isn't included since we're building only for linux.
    ./0000-fix_mkorder.patch
    ./0001-fix-compilation.patch
  ];

  enableParallelBuilding = true;

  # The dependencies and their justification are explained at
  # http://smalltalk.gnu.org/download
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libtool
    zip
    libffi
    libsigsegv-shared
    readline
    gmp
    gnutls
    gtk2
    cairo
    SDL
    sqlite
  ]
  ++ lib.optional emacsSupport emacs;

  configureFlags = lib.optional (!emacsSupport) "--without-emacs";

  hardeningDisable = [ "format" ];

  installFlags = lib.optional emacsSupport "lispdir=${placeholder "$out"}/share/emacs/site-lisp";

  # For some reason the tests fail if executated with nix-build, but pass if
  # executed within nix-shell --pure.
  doCheck = false;

  meta = {
    description = "Free implementation of the Smalltalk-80 language";
    longDescription = ''
      GNU Smalltalk is a free implementation of the Smalltalk-80 language. It
      runs on most POSIX compatible operating systems (including GNU/Linux, of
      course), as well as under Windows. Smalltalk is a dynamic object-oriented
      language, well-versed to scripting tasks.
    '';
    homepage = "http://smalltalk.gnu.org/";
    license = with lib.licenses; [
      gpl2
      lgpl2
    ];
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
