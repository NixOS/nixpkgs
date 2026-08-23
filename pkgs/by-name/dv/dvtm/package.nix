{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  # if you prefer a custom config, write the config.h in dvtm.config.h
  # and enable
  # customConfig = builtins.readFile ./dvtm.config.h;
  customConfig ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dvtm";
  version = "0.15";

  src = fetchurl {
    url = "https://www.brain-dump.org/projects/dvtm/dvtm-${finalAttrs.version}.tar.gz";
    hash = "sha256-jyAVwF4q2C8SrkzxKzY9NPUnpLvIw2lmfyOeRULh5RA=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  patches = [
    # https://github.com/martanne/dvtm/pull/69
    # Use self-pipe instead of signal blocking fixes issues on darwin.
    (fetchurl {
      url = "https://github.com/martanne/dvtm/commit/1f1ed664d64603f3f1ce1388571227dc723901b2.patch";
      hash = "sha256-LWMWFLOX95Nl0zflSdD3Z3JU3+fZ0e6Rwh/uyUZHfrE=";
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
