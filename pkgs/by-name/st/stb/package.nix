{
  lib,
  stdenv,
  fetchFromGitHub,
  copyPkgconfigItems,
  makePkgconfigItem,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stb";
  version = "0-unstable-2026-11-06";

  src = fetchFromGitHub {
    owner = "nothings";
    repo = "stb";
    rev = "4e9b368bfc071e97206ea5c6adba68dd0cbf8897";
    hash = "sha256-8kUcP5UWqjX5WncA/fEKO1JzMm7Gp+PsGkb+PGBf6lQ=";
  };

  nativeBuildInputs = [ copyPkgconfigItems ];

  pkgconfigItems = [
    (makePkgconfigItem rec {
      name = "stb";
      version = "1";
      cflags = [ "-I${variables.includedir}/stb" ];
      variables = rec {
        prefix = "${placeholder "out"}";
        includedir = "${prefix}/include";
      };
      inherit (finalAttrs.meta) description;
    })
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/include/stb
    cp *.h $out/include/stb/
    cp *.c $out/include/stb/
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Single-file public domain libraries for C/C++";
    homepage = "https://github.com/nothings/stb";
    license = with lib.licenses; [
      mit
      # OR
      unlicense
    ];
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
