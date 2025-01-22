{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libudfread";
  version = "1.1.2";

  src = fetchurl {
    url = "https://code.videolan.org/videolan/${pname}/-/archive/${version}/${pname}-${version}.tar.gz";
    sha256 = "1idsfxff1x264n8jd7077qrd61rycsd09fwmc4ar7l4qmhk6gw9b";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "UDF reader";
    homepage = "https://code.videolan.org/videolan/libudfread";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ chkno ];
    platforms = platforms.all;
  };
}
