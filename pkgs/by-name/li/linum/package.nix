{
  alsa-lib,
  fetchFromGitea,
  lib,
  libpulseaudio,
  stdenv,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linum";
  version = "1.0.7";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "oxetene";
    repo = "linum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vqWeCtLxX9a63oQunePhv4ZMXIj3MlPKuAYFts0REzg=";
  };

  installPhase = ''
    runHook preInstall

    install -D linum $out/bin/${finalAttrs.meta.mainProgram}

    runHook postInstall
  '';

  # Miniaudio loads its playback backends with dlopen at runtime
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        alsa-lib
        libpulseaudio
      ]
    } $out/bin/${finalAttrs.meta.mainProgram}
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
    platforms = lib.platforms.unix;
  };
})
