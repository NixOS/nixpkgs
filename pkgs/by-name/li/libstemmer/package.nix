{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libstemmer";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "snowballstem";
    repo = "snowball";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FpvV2brpjl0/l/EmrHN9tWFrXUUz9BDUH548MAjiTa8=";
  };

  nativeBuildInputs = [ perl ];

  strictDeps = true;

  prePatch = ''
    patchShebangs .
  ''
  + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace GNUmakefile \
      --replace-fail './snowball ' '${lib.getExe' buildPackages.libstemmer "snowball"} '
  '';

  makeTarget = "libstemmer.a";

  installPhase = ''
    runHook preInstall
    install -Dt $out/lib libstemmer.a
    install -Dt $out/include include/libstemmer.h
    install -Dt $out/bin {snowball,stemwords}
    runHook postInstall
  '';

  __structuredAttrs = true;

  meta = {
    description = "Snowball Stemming Algorithms";
    homepage = "https://snowballstem.org/";
    changelog = "https://github.com/snowballstem/snowball/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.all;
  };
})
