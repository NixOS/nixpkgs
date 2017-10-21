{ stdenv, fetchurl, alsaLib, bison, flex, libsndfile, which }:

stdenv.mkDerivation rec {
  version = "1.3.5.2";
  name = "chuck-${version}";

  src = fetchurl {
    url = "http://chuck.cs.princeton.edu/release/files/chuck-${version}.tgz";
    sha256 = "02z7sglax3j09grj5s1skmw8z6wz7b21hjrm95nrrdpwbxabh079";
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

  meta = with stdenv.lib; {
    description = "Programming language for real-time sound synthesis and music creation";
    homepage = http://chuck.cs.princeton.edu;
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ ftrvxmtrx ];
  };
}
