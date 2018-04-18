{ stdenv, fetchurl, alsaLib, bison, flex, libsndfile, which
, AppKit, Carbon, CoreAudio, CoreMIDI, CoreServices, Kernel
}:

stdenv.mkDerivation rec {
  version = "1.3.5.2";
  name = "chuck-${version}";

  src = fetchurl {
    url = "http://chuck.cs.princeton.edu/release/files/chuck-${version}.tgz";
    sha256 = "02z7sglax3j09grj5s1skmw8z6wz7b21hjrm95nrrdpwbxabh079";
  };

  buildInputs = [ bison flex libsndfile which ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) alsaLib
    ++ stdenv.lib.optional stdenv.isDarwin [ AppKit Carbon CoreAudio CoreMIDI CoreServices Kernel ];

  patches = [ ./clang.patch ./darwin-limits.patch ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-Wno-missing-sysroot";
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-framework MultitouchSupport";

  postPatch = ''
    substituteInPlace src/makefile --replace "/usr/bin" "$out/bin"
    substituteInPlace src/makefile.osx --replace "xcodebuild" "/usr/bin/xcodebuild"
    substituteInPlace src/makefile.osx --replace "weak_framework" "framework"
    substituteInPlace src/makefile.osx --replace "MACOSX_DEPLOYMENT_TARGET=10.5" "MACOSX_DEPLOYMENT_TARGET=$MACOSX_DEPLOYMENT_TARGET"
  '';

  buildPhase = ''
    make -C src ${if stdenv.isDarwin then "osx" else "linux-alsa"}
  '';

  installPhase = ''
    install -Dm755 ./src/chuck $out/bin/chuck
  '';

  meta = with stdenv.lib; {
    description = "Programming language for real-time sound synthesis and music creation";
    homepage = http://chuck.cs.princeton.edu;
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ ftrvxmtrx ];
  };
}
