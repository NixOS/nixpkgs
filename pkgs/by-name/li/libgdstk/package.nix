{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,

  # build-time deps
  cmake,
  ninja,

  # run-time deps
  zlib,
  qhull,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgdstk";
  version = "0.9.61";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "heitzmann";
    repo = "gdstk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-soU+6EbyOkHGvVq230twiRzywOskhkkXFr5akBpvgBw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    zlib
    qhull
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++/Python library for creation and manipulation of GDSII and OASIS files";
    homepage = "https://github.com/heitzmann/gdstk";
    changelog = "https://github.com/heitzmann/gdstk/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [
      eljamm
      gonsolo
    ];
    teams = with lib.teams; [ ngi ];
  };
})
