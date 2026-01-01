{
  stdenv,
  lib,
  fetchurl,
  alsa-lib,
  bison,
  flex,
  libsndfile,
  which,
  DarwinTools,
  xcbuild,
}:

stdenv.mkDerivation rec {
  version = "1.4.2.0";
  pname = "chuck";

  src = fetchurl {
    url = "http://chuck.cs.princeton.edu/release/files/chuck-${version}.tgz";
    sha256 = "sha256-hIwsC9rYgXWSTFqUufKGqoT0Gnsf4nR4KQ0iSVbj8xg=";
  };

  nativeBuildInputs = [
    flex
    bison
    which
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    DarwinTools
    xcbuild
  ];

  buildInputs = [ libsndfile ] ++ lib.optional (!stdenv.hostPlatform.isDarwin) alsa-lib;

  patches = [ ./darwin-limits.patch ];

  makeFlags = [
    "-C src"
    "DESTDIR=$(out)/bin"
  ];
  buildFlags = [ (if stdenv.hostPlatform.isDarwin then "mac" else "linux-alsa") ];

<<<<<<< HEAD
  meta = {
    description = "Programming language for real-time sound synthesis and music creation";
    homepage = "http://chuck.cs.princeton.edu";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ftrvxmtrx ];
=======
  meta = with lib; {
    description = "Programming language for real-time sound synthesis and music creation";
    homepage = "http://chuck.cs.princeton.edu";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ftrvxmtrx ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "chuck";
  };
}
