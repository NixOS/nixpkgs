{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  xcbuild,
}:

let
  version = "13.29.1";
  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-tools";
    rev = "refs/tags/v${version}";
    hash = "sha256-j6luT+L/vN9qaGjjeMW+8QGuzjJxzbn0sMGDjhqoeZA=";
  };
in
buildNpmPackage {
  pname = "firebase-tools";
  inherit version src;

  npmDepsHash = "sha256-3+XeXK3VGIs4Foi9iW9Kho/Y0JsTQZ7p+582MPgdH1A=";

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
