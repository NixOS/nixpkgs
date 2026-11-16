{
  lib,
  stdenv,
  fetchurl,
  libaio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blktrace";
  version = "1.3.0";

  # Official source
  # "https://git.kernel.org/pub/scm/linux/kernel/git/axboe/blktrace.git"
  src = fetchurl {
    url = "https://brick.kernel.dk/snaps/blktrace-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-1t7aA4Yt4r0bG5+6cpu7hi2bynleaqf3yoa2VoEacNY=";
  };

  buildInputs = [ libaio ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CC:=$(CC)"
  ];

  meta = {
    description = "Block layer IO tracing mechanism";
    maintainers = with lib.maintainers; [ nickcao ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
