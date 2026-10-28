{
  lib,
  fetchFromSourcehut,
  buildGoModule,
  unstableGitUpdater,
}:

buildGoModule {
  pname = "gssg";
  version = "0-unstable-2023-05-29";

  src = fetchFromSourcehut {
    owner = "~gsthnz";
    repo = "gssg";
    rev = "fc755f281d750d0b022689d58d0f32e6799dfef8";
    hash = "sha256-m0bVH6upLSA1dcxds3VJFFaSYs7YoMuoAmEe5qAUTmw=";
  };

  vendorHash = "sha256-NxfZbwKo8SY0XfWivQ42cNqIbJQ1EBsxPFr70ZU9G6E=";

  ldFlags = [
    "-s"
    "-w"
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Gemini static site generator";
    homepage = "https://git.sr.ht/~gsthnz/gssg";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "gssg";
  };
}
