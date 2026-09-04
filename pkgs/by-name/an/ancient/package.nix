{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  autoconf-archive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ancient";
  version = "2.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "temisu";
    repo = "ancient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-raRKg4Gm4JFaTGbuBldCOGEAAAQjf92Ud99lyFa/u2w=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    autoconf-archive
  ];

  meta = {
    description = "Modern decompressor for old data compression formats";
    longDescription = ''
      Collection of decompression routines for old formats
      popular in the Amiga, Atari, and some other systems from
      the 80's and 90's, as well as some that are currently
      used which were used in some specific way in these old systems.
    '';
    homepage = "https://github.com/temisu/ancient/";
    changelog = "https://github.com/temisu/ancient/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      bsd2
      bzip2
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ treierxyz ];
    mainProgram = "ancient";
  };
})
