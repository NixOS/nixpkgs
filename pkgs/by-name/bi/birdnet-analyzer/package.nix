{
  lib,
  python3Packages,
  fetchFromGitHub,
  unstableGitUpdater,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  __structuredAttrs = true;

  pname = "birdnet-analyzer";
  version = "2.4.0-unstable-2026-06-12";

  # Using an unstable version because an older version was touching the
  # RO nix store
  src = fetchFromGitHub {
    owner = "birdnet-team";
    repo = "BirdNET-Analyzer";
    rev = "80d30e60a36d809c5bc6b9e0ba830317125e8c71";
    hash = "sha256-ucU2BU7knO6qzrjek/a2Qo8pqk/jiMpa7/KO0iuU7dY=";
  };

  pyproject = true;

  build-system = [
    python3Packages.setuptools
  ];

  # GUI doesn't work as they have not migrated to the new Gradio
  dependencies = with python3Packages; [
    librosa
    resampy
    tensorflow
    pyarrow
    tqdm
    pandas
    matplotlib
    birdnet
  ];

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    homepage = "https://birdnet.cornell.edu/birdnet";
    donationPage = "https://birdnet.cornell.edu/donate";
    downloadPage = "https://github.com/birdnet-team/BirdNET-Analyzer/releases";
    mainProgram = "birdnet-analyzer";
    license = [
      lib.licenses.mit
    ];
    maintainers = [
      lib.maintainers.RossSmyth
    ];
  };

})
