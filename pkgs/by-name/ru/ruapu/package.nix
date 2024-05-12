{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ruapu";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "nihui";
    repo = "ruapu";
    rev = finalAttrs.version;
    hash = "sha256-gP2O0KtzArNCU3Sqc7STitO6WkS1536Z4VkA5U1uZuc=";
  };

  buildPhase = ''
    runHook preBuild

    $CC main.c -o ruapu

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ruapu $out/bin/ruapu
    install -Dm644 ruapu.h $out/include/ruapu.h

    runHook postInstall
  '';

  meta = {
    description = "Detect CPU ISA features with single-file";
    homepage = "https://github.com/nihui/ruapu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "ruapu";
    platforms = lib.platforms.all;
  };
})
