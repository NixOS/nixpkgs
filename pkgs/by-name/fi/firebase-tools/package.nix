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
  version = "14.18.0";

  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-tools";
    tag = "v${version}";
    hash = "sha256-1yTcMzyznr0b/ObVEECdJuBUi03aiTAwgcTdJ1QFcWY=";
  };

  npmDepsHash = "sha256-VJquJ7mDBHeclgd/jsAPyRLEFOQp27tUXGAQJX3bXyQ=";

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';

  nativeBuildInputs = [
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
