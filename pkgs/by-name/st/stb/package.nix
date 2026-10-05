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
  version = "0-unstable-2026-04-15";

  src = fetchFromGitHub {
    owner = "nothings";
    repo = "stb";
    rev = "31c1ad37456438565541f4919958214b6e762fb4";
    hash = "sha256-m2yNUlA37hDkKQVrQ+R8nufHfW/cXLnMo+n1X1Cyun0=";
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
