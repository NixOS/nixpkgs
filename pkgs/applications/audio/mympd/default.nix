{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
, mpd_clientlib
, openssl
, lua5_3
, libid3tag
, flac
, mongoose
}:

stdenv.mkDerivation rec {
  pname = "mympd";
  version = "6.8.1";

  src = fetchFromGitHub {
    owner = "jcorporation";
    repo = "myMPD";
    rev = "v${version}";
    sha256 = "dIGg2mLxN6XBDH3GFXtF7nB9a/zf/qMlPCvIulFRXn8=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    mpd_clientlib
    openssl
    lua5_3
    libid3tag
    flac
  ];

  cmakeFlags = [
    "-DENABLE_LUA=ON"
    # Otherwise, it tries to parse $out/etc/mympd.conf on startup.
    "-DCMAKE_INSTALL_SYSCONFDIR=/etc"
    # similarly here
    "-DCMAKE_INSTALL_LOCALSTATEDIR=/var/lib/mympd"
  ];
  # See https://github.com/jcorporation/myMPD/issues/315
  hardeningDisable = [ "strictoverflow" ];

  meta = {
    homepage = "https://jcorporation.github.io/mympd";
    description = "A standalone and mobile friendly web mpd client with a tiny footprint and advanced features";
    maintainers = [ stdenv.lib.maintainers.doronbehar ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
