{
  lib,
  stdenv,
  fetchurl,
  libaio,
}:

stdenv.mkDerivation rec {
  pname = "blktrace";
  version = "1.3.0";

  # Official source
  # "https://git.kernel.org/pub/scm/linux/kernel/git/axboe/blktrace.git"
  src = fetchurl {
    url = "https://brick.kernel.dk/snaps/blktrace-${version}.tar.bz2";
    sha256 = "sha256-1t7aA4Yt4r0bG5+6cpu7hi2bynleaqf3yoa2VoEacNY=";
  };

  buildInputs = [ libaio ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CC:=$(CC)"
  ];

  meta = with lib; {
    description = "Block layer IO tracing mechanism";
    maintainers = with maintainers; [ nickcao ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
