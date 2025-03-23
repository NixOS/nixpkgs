{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "mjmap";
  version = "0.1.0-unstable-2025-03-06";

  src = fetchFromSourcehut {
    owner = "~rockorager";
    repo = "mjmap";
    rev = "fdc1658f1a3d57594479535692ed06c6e19cc859";
    hash = "sha256-178S4Y4h31z0OCedS44udxyv8TfgZoDykApg3pX15oQ=";
  };

  vendorHash = "sha256-fJuPrzjRH0FpYj2D9CsFdsdzYT0C3/D2PhmJIZTsgfQ=";

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/mjmap --version >/dev/null

    runHook postInstallCheck
  '';

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v.";
  };

  meta = {
    description = "Sendmail‐compatible JMAP client";
    homepage = "https://git.sr.ht/~rockorager/mjmap";
    license = lib.licenses.mpl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.emily ];
    mainProgram = "mjmap";
    platforms = lib.platforms.unix;
  };
}
