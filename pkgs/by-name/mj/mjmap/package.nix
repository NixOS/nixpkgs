{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "mjmap";
  version = "0.1.0-unstable-2023-11-13";

  src = fetchFromSourcehut {
    owner = "~rockorager";
    repo = "mjmap";
    rev = "d54badae8152b4db6eec8b03a7bd7c5ff1724aa7";
    hash = "sha256-yFYYnklNNOHTfoT54kOIVoM4t282/0Ir4l72GmqlGSY=";
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

  meta = with lib; {
    description = "Sendmail‐compatible JMAP client";
    homepage = "https://git.sr.ht/~rockorager/mjmap";
    license = licenses.mpl20;
    sourceProvenance = [ sourceTypes.fromSource ];
    maintainers = [ maintainers.emily ];
    mainProgram = "mjmap";
    platforms = platforms.unix;
  };
}
