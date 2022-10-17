{ stdenv, lib, fetchurl, alsa-lib, bison, flex, libsndfile, which
, AppKit, Carbon, CoreAudio, CoreMIDI, CoreServices, Kernel
}:

stdenv.mkDerivation rec {
  version = "1.4.1.0";
  pname = "chuck";

  src = fetchurl {
    url = "http://chuck.cs.princeton.edu/release/files/chuck-${version}.tgz";
    sha256 = "sha256-dL+ZrVFeMRPFW4MxUpNvrQKjzwBqVBBf8Rd3xHMZSSg=";
  };

  nativeBuildInputs = [ flex bison which ];

  buildInputs = [ libsndfile ]
    ++ lib.optional (!stdenv.isDarwin) alsa-lib
    ++ lib.optional stdenv.isDarwin [ AppKit Carbon CoreAudio CoreMIDI CoreServices Kernel ];

  patches = [ ./darwin-limits.patch ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-Wno-missing-sysroot";
  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework MultitouchSupport";

  postPatch = ''
    substituteInPlace src/core/makefile.x/makefile.osx \
      --replace "weak_framework" "framework" \
      --replace "MACOSX_DEPLOYMENT_TARGET=10.9" "MACOSX_DEPLOYMENT_TARGET=$MACOSX_DEPLOYMENT_TARGET"
  '';

  makeFlags = [ "-C src" "DESTDIR=$(out)/bin" ];
  buildFlags = [ (if stdenv.isDarwin then "osx" else "linux-alsa") ];

  meta = with lib; {
    description = "Programming language for real-time sound synthesis and music creation";
    homepage = "http://chuck.cs.princeton.edu";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ftrvxmtrx ];
  };
}
