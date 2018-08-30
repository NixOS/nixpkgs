{ stdenv, lib, fetchurl, alsaLib, bison, flex, libsndfile, which
, AppKit, Carbon, CoreAudio, CoreMIDI, CoreServices, Kernel
, xcbuild
}:

stdenv.mkDerivation rec {
  version = "1.3.5.2";
  name = "chuck-${version}";

  src = fetchurl {
    url = "http://chuck.cs.princeton.edu/release/files/chuck-${version}.tgz";
    sha256 = "02z7sglax3j09grj5s1skmw8z6wz7b21hjrm95nrrdpwbxabh079";
  };

  nativeBuildInputs = [ flex bison which ];

  buildInputs = [ libsndfile ]
    ++ lib.optional (!stdenv.isDarwin) alsaLib
    ++ lib.optional stdenv.isDarwin [ AppKit Carbon CoreAudio CoreMIDI CoreServices Kernel ];

  patches = [ ./clang.patch ./darwin-limits.patch ];

  NIX_CFLAGS_COMPILE = lib.optional stdenv.isDarwin "-Wno-missing-sysroot";
  NIX_LDFLAGS = lib.optional stdenv.isDarwin "-framework MultitouchSupport";

  postPatch = ''
    substituteInPlace src/makefile --replace "/usr/bin" "$out/bin"
    substituteInPlace src/makefile.osx \
      --replace "weak_framework" "framework" \
      --replace "MACOSX_DEPLOYMENT_TARGET=10.5" "MACOSX_DEPLOYMENT_TARGET=$MACOSX_DEPLOYMENT_TARGET"
  '';

  makeFlags = [ "-C src" "DESTDIR=$(out)/bin" ];
  buildFlags = [ (if stdenv.isDarwin then "osx" else "linux-alsa") ];

  meta = with lib; {
    description = "Programming language for real-time sound synthesis and music creation";
    homepage = http://chuck.cs.princeton.edu;
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ ftrvxmtrx ];
  };
}
