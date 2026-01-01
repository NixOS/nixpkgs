{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "libstemmer";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "snowballstem";
    repo = "snowball";
    rev = "v${version}";
    sha256 = "sha256-qXrypwv/I+5npvGHGsHveijoui0ZnoGYhskCfLkewVE=";
  };

  nativeBuildInputs = [ perl ];

  prePatch = ''
    patchShebangs .
  ''
  + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace GNUmakefile \
      --replace './snowball' '${lib.getBin buildPackages.libstemmer}/bin/snowball'
  '';

  makeTarget = "libstemmer.a";

  installPhase = ''
    runHook preInstall
    install -Dt $out/lib libstemmer.a
    install -Dt $out/include include/libstemmer.h
    install -Dt $out/bin {snowball,stemwords}
    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Snowball Stemming Algorithms";
    homepage = "https://snowballstem.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Snowball Stemming Algorithms";
    homepage = "https://snowballstem.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
