{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libstemmer";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "snowballstem";
    repo = "snowball";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N5grPCbly0hp0n7RlqkQDztdjvSb1VtzLAJT68T6ng4=";
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
