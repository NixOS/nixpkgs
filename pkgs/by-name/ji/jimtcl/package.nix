{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  asciidoc,
  pkg-config,
  inetutils,
  tcl,

  sqlite,
  readline,
  SDL2,
  SDL2_gfx,
  openssl,

  SDLSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jimtcl";
  version = "0.83";

  src = fetchFromGitHub {
    owner = "msteveb";
    repo = "jimtcl";
    rev = finalAttrs.version;
    sha256 = "sha256-O7hYQgI5P9jpX1Emb4NeDTtIlALXBeJI+RMca7638Ug=";
  };

  # https://github.com/msteveb/jimtcl/issues/308
  patches = [
    (fetchpatch {
      name = "jimtcl-readline-stdio.patch";
      url = "https://github.com/msteveb/jimtcl/commit/35e0e1f9b1f018666e5170a35366c5fc3b97309c.patch";
      hash = "sha256-EvhDoovEGcGjBsS/4g5bv/x7smdUZEL6L+KeHTfzY14=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    asciidoc
    tcl
  ];

  buildInputs =
    [
      sqlite
      readline
      openssl
    ]
    ++ (lib.optionals SDLSupport [
      SDL2
      SDL2_gfx
    ]);

  configureFlags = [
    "--shared"
    "--with-ext=oo"
    "--with-ext=tree"
    "--with-ext=binary"
    "--with-ext=sqlite3"
    "--with-ext=readline"
    "--with-ext=json"
    "--ipv6"
  ] ++ (lib.optional SDLSupport "--with-ext=sdl");

  enableParallelBuilding = true;

  doCheck = true;
  preCheck = ''
    # test exec2-3.2 fails depending on platform or sandboxing (?)
    rm tests/exec2.test
    # requires internet access
    rm tests/ssl.test
    # test fails due to timing in some environments
    # https://github.com/msteveb/jimtcl/issues/282
    rm tests/timer.test
  '';

  # test posix-1.6 needs the "hostname" command
  nativeCheckInputs = [ inetutils ];

  meta = {
    description = "Open source small-footprint implementation of the Tcl programming language";
    homepage = "http://jim.tcl.tk/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      dbohdan
      fgaz
    ];
  };
})
