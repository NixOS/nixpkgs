{ stdenv, lib, fetchurl, alsa-lib, bison, flex, libsndfile, which, DarwinTools, xcbuild
, AppKit, Carbon, CoreAudio, CoreMIDI, CoreServices, Kernel, MultitouchSupport
}:

stdenv.mkDerivation rec {
  version = "1.4.2.0";
  pname = "chuck";

  src = fetchurl {
    url = "http://chuck.cs.princeton.edu/release/files/chuck-${version}.tgz";
    sha256 = "sha256-hIwsC9rYgXWSTFqUufKGqoT0Gnsf4nR4KQ0iSVbj8xg=";
  };

  nativeBuildInputs = [ flex bison which ]
    ++ lib.optionals stdenv.isDarwin [ DarwinTools xcbuild ];

  buildInputs = [ libsndfile ]
    ++ lib.optional (!stdenv.isDarwin) alsa-lib
    ++ lib.optionals stdenv.isDarwin [ AppKit Carbon CoreAudio CoreMIDI CoreServices Kernel MultitouchSupport ];

  patches = [ ./darwin-limits.patch ];

  makeFlags = [ "-C src" "DESTDIR=$(out)/bin" ];
  buildFlags = [ (if stdenv.isDarwin then "mac" else "linux-alsa") ];

  meta = with lib; {
    description = "Programming language for real-time sound synthesis and music creation";
    homepage = "http://chuck.cs.princeton.edu";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ftrvxmtrx ];
    mainProgram = "chuck";
  };
}
