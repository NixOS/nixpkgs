{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libstemmer";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "snowballstem";
    repo = "snowball";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qXrypwv/I+5npvGHGsHveijoui0ZnoGYhskCfLkewVE=";
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
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.all;
  };
})
