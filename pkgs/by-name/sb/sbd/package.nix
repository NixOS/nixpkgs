{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sbd";
  version = "1.37";

  src = fetchurl {
    url = "https://web.archive.org/web/20220626230420/http://www.tigerteam.se/dl/sbd/sbd-${finalAttrs.version}.tar.gz";
    hash = "sha256-Qt5Q3PynV80DAXxuVqx6L4dTKgjnBDQjzSDZEf1kX10=";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CC=cc"
  ];

  buildFlags = lib.optional stdenv.isLinux "unix"
               ++ lib.optional stdenv.isDarwin "darwin";

  meta = with lib; {
    description = "Netcat-clone, portable, offers strong encryption - features AES-128-CBC + HMAC-SHA1 encryption, program execution, choosing source port, continuous reconnection with delay and more";
    mainProgram = "sbd";
    homepage = "https://web.archive.org/web/20220626230420/http://www.tigerteam.se/dl/sbd/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
  };
})
