{
  lib,
  stdenv,
  fetchpatch,
  fetchzip,
  ncurses,
  customConfig ? null,
}:

let
  rev = "7bcf43f8dbd5c4a67ec573a1248114caa75fa3c2";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dvtm-unstable";
  version = "0.15-unstable-2021-03-09";

  src = fetchzip {
    urls = [
      "https://github.com/martanne/dvtm/archive/${rev}.tar.gz"
      "https://git.sr.ht/~martanne/dvtm/archive/${rev}.tar.gz"
    ];
    hash = "sha256-UtkNsW0mvLfbPSAIIZ1yvX9xzIDtiBeXCjhN2R8JhDc=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  patches = [
    # https://github.com/martanne/dvtm/pull/69
    # Use self-pipe instead of signal blocking fixes issues on darwin.
    (fetchpatch {
      name = "use-self-pipe-fix-darwin";
      url = "https://github.com/martanne/dvtm/commit/1f1ed664d64603f3f1ce1388571227dc723901b2.patch";
      hash = "sha256-69L4w5vPZfAzBnGDmwW4cB44VAtbECICxmaHdfScQ5I=";
    })
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    CFLAGS = "-D_DARWIN_C_SOURCE";
  };

  postPatch = lib.optionalString (customConfig != null) ''
    cp ${builtins.toFile "config.h" customConfig} ./config.h
  '';

  nativeBuildInputs = [ ncurses ];
  buildInputs = [ ncurses ];

  # 'tic' does not reliably create the target directory, so we make it first
  preInstall = ''
    mkdir -p $out/share/terminfo
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "TERMINFO=$(out)/share/terminfo"
  ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "Dynamic virtual terminal manager";
    homepage = "https://www.brain-dump.org/projects/dvtm";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "dvtm";
    platforms = lib.platforms.unix;
  };
})
