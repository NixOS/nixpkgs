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
  version = "0-unstable-2026-08-01";

  src = fetchFromGitHub {
    owner = "nothings";
    repo = "stb";
    rev = "2c980bb59875b0d32144a71867fbdebb2f77cd20";
    hash = "sha256-vA5RZLte4gf5/NkbWT3VNzGVD04kyVTHPeEZwxNnxi0=";
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
