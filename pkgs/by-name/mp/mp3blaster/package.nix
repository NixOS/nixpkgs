{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  ncurses,
  libvorbis,
  SDL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mp3blaster";
  version = "3.2.6";

  src = fetchFromGitHub {
    owner = "stragulus";
    repo = "mp3blaster";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gke6OjcrDlF3CceSVyfu8SGd0004cef8RlZ76Aet/F8=";
  };

  patches = [
    # Fix pending upstream inclusion for ncurses-6.3 support:
    #  https://github.com/stragulus/mp3blaster/pull/8
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/stragulus/mp3blaster/commit/62168cba5eaba6ffe56943552837cf033cfa96ed.patch";
      hash = "sha256-4Xcg7/7nKc7iiBZe5otIXjZNjBW9cOs6p6jQQOcRFCE=";
    })
  ];

  buildInputs = [
    ncurses
    libvorbis
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin SDL;

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-Wno-narrowing"
    ]
    ++ lib.optionals stdenv.cc.isClang [
      "-Wno-reserved-user-defined-literal"
      "-Wno-register"
    ]
  );

  meta = {
    description = "Audio player for the text console";
    homepage = "http://www.mp3blaster.org/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ earldouglas ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
