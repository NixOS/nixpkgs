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
  version = "0-unstable-2026-10-22";

  src = fetchFromGitHub {
    owner = "nothings";
    repo = "stb";
    rev = "003501f6d7a8668ce8b6d875e34dd97ad0d5d5b5";
    hash = "sha256-tvt5gGQjeYNaoYzKgN6dPDtfN1Ylmqae5tYGYNsoi1M=";
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
