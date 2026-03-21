{
  fetchFromGitea,
  lib,
  stdenv,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linum";
  version = "1.0.6";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "oxetene";
    repo = "linum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ktc3GF+lUhlghUbPes4Th07sRmTzsx2A/4PmcIsb7/Y=";
  };

  installPhase = ''
    runHook preInstall

    install -D linum $out/bin/${finalAttrs.meta.mainProgram}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple musical notation and synthesizer";
    longDescription = ''
      Linum is a minimalist musical notation system paired with an
      audio synthesizer.  It aims to provide the simplest, most
      compact way to write music in a textual format, making it ideal
      for quick drafting of melodies or transcription of existing
      pieces.  Through the use of numbers to represent notes, Linum
      also supports unconventional tunings and microtonal music.
    '';
    homepage = "https://linum-notation.org";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "linum";
    platforms = lib.platforms.all;
  };
})
