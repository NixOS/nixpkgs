{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "libstemmer";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "snowballstem";
    repo = "snowball";
    rev = "v${version}";
    sha256 = "sha256-QPIPePddUqwpa0YMn0E7H9GZj3s2bEkJzZdXlrHeZbo=";
  };

  nativeBuildInputs = [ perl ];

  prePatch =
    ''
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

  meta = with lib; {
    description = "Snowball Stemming Algorithms";
    homepage = "https://snowballstem.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.all;
  };
}
