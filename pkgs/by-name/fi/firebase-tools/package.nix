{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  xcbuild,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "firebase-tools";
  version = "14.7.0";

  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-tools";
    tag = "v${version}";
    hash = "sha256-sZQoP6XsJkDI6I41eQv678aDtHhaRX6u03z/D6S7nBQ=";
  };

  npmDepsHash = "sha256-QrJgImV7YCzME/ZwzwJP3FFvonmvCSm0hd9fLc8gyyk=";

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

  env.PUPPETEER_SKIP_DOWNLOAD = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/firebase/firebase-tools/blob/v${version}/CHANGELOG.md";
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
