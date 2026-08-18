{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libudfread";
  version = "1.1.2";

  src = fetchurl {
    url = "https://code.videolan.org/videolan/libudfread/-/archive/${finalAttrs.version}/libudfread-${finalAttrs.version}.tar.gz";
    sha256 = "1idsfxff1x264n8jd7077qrd61rycsd09fwmc4ar7l4qmhk6gw9b";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "UDF reader";
    homepage = "https://code.videolan.org/videolan/libudfread";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ chkno ];
    platforms = lib.platforms.all;
  };
})
