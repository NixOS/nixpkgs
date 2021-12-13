{ cmake
, pkg-config
, alsa-lib
, boost
, curl
, fetchFromGitHub
, fetchpatch
, ffmpeg
, lame
, libev
, libmicrohttpd
, ncurses
, pulseaudio
, lib, stdenv
, taglib
, systemdSupport ? stdenv.isLinux, systemd
}:

stdenv.mkDerivation rec {
  pname = "musikcube";
  version = "0.96.7";

  src = fetchFromGitHub {
    owner = "clangen";
    repo = pname;
    rev = version;
    sha256 = "1y00vwn1h10cfflxrm5bk271ak9gilhjycgi44hlkkhmf5bdgn35";
  };

  patches = [
    # Fix pending upstream inclusion for ncuurses-6.3 support:
    #  https://github.com/clangen/musikcube/pull/474
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/clangen/musikcube/commit/1240720e27232fdb199a4da93ca6705864442026.patch";
      sha256 = "0bhjgwnj6d24wb1m9xz1vi1k9xk27arba1absjbcimggn54pinid";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    alsa-lib
    boost
    curl
    ffmpeg
    lame
    libev
    libmicrohttpd
    ncurses
    pulseaudio
    taglib
  ] ++ lib.optional systemdSupport systemd;

  cmakeFlags = [
    "-DDISABLE_STRIP=true"
  ];

  meta = with lib; {
    description = "A fully functional terminal-based music player, library, and streaming audio server";
    homepage = "https://musikcube.com/";
    maintainers = [ maintainers.aanderse ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
