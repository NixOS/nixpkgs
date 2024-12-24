{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  xcbuild,
}:

let
  version = "13.28.0";
  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-tools";
    rev = "refs/tags/v${version}";
    hash = "sha256-bOuOBzEEfVi+0lGqKgZQVmxKUBWoWWdaQ1jlCR1xBcM=";
  };
in
buildNpmPackage {
  pname = "firebase-tools";
  inherit version src;

  npmDepsHash = "sha256-3wc1DPZ+yYlBtUTWpa4XFaetS7caNqX5JFSXkmzHyqg=";

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
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
