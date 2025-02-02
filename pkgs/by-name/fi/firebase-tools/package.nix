{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  xcbuild,
  fetchpatch,
}:
let
  version = "13.29.2";
  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-tools";
    tag = "v${version}";
    hash = "sha256-A/UHJC1BY2A/Zezdvq3W7Ra55TEwqTaYDI8VTwy7yrA=";
  };
in
buildNpmPackage {
  pname = "firebase-tools";
  inherit version src;

  npmDepsHash = "sha256-5ARfYHmWJFaO7pngWVDQ7R3PAopg4+2Q2kspBTpKclM=";

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';

  nativeBuildInputs =
    [
      python3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      xcbuild
    ];

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  meta = {
    changelog = "https://github.com/firebase/firebase-tools/blob/${src.rev}/CHANGELOG.md";
    description = "Manage, and deploy your Firebase project from the command line";
    homepage = "https://github.com/firebase/firebase-tools";
    license = lib.licenses.mit;
    mainProgram = "firebase";
    maintainers = with lib.maintainers; [
      momeemt
      sarahec
    ];
  };
}
