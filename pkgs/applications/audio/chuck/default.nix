{ stdenv, fetchurl, alsaLib, bison, flex, libsndfile, which }:

stdenv.mkDerivation rec {
  version = "1.3.4.0";
  name = "chuck-${version}";

  src = fetchurl {
    url = "http://chuck.cs.princeton.edu/release/files/chuck-${version}.tgz";
    sha256 = "0cwbk8b1i18nkh2nxwzk2prranw83lgglxw7ccnp6b0r2b2yfpmn";
  };

  buildInputs = [ bison flex libsndfile which ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) alsaLib;

  patches = [ ./darwin-limits.patch ];

  postPatch = ''
    substituteInPlace src/makefile --replace "/usr/bin" "$out/bin"
    substituteInPlace src/makefile.osx --replace "xcodebuild" "/usr/bin/xcodebuild"
    substituteInPlace src/makefile.osx --replace "weak_framework" "framework"
  '';

  buildPhase =
    stdenv.lib.optionals stdenv.isLinux  ["make -C src linux-alsa"] ++
    stdenv.lib.optionals stdenv.isDarwin ["make -C src osx"];

  installPhase = ''
    install -Dm755 ./src/chuck $out/bin/chuck
  '';

  meta = {
    description = "Programming language for real-time sound synthesis and music creation";
    homepage = http://chuck.cs.princeton.edu;
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ ftrvxmtrx ];
  };
}
