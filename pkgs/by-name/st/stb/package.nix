{
  lib,
  stdenv,
  fetchFromGitHub,
  copyPkgconfigItems,
  makePkgconfigItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stb";
  version = "0-unstable-2025-10-26";

  src = fetchFromGitHub {
    owner = "nothings";
    repo = "stb";
    rev = "f1c79c02822848a9bed4315b12c8c8f3761e1296";
    hash = "sha256-BlyXJtAI7WqXCTT3ylww8zoG0hBxaojJnQDvdQOXJPE=";
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

  meta = {
    description = "Single-file public domain libraries for C/C++";
    homepage = "https://github.com/nothings/stb";
    license = with lib.licenses; [
      mit
      # OR
      unlicense
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ peng0in ];
  };
})
