{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libstemmer";
  version = "3.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snowballstem";
    repo = "snowball";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-QPIPePddUqwpa0YMn0E7H9GZj3s2bEkJzZdXlrHeZbo=";
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

  meta = {
    description = "Snowball Stemming Algorithms";
    homepage = "https://snowballstem.org/";
    changelog = "https://github.com/snowballstem/snowball/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.all;
  };
})
