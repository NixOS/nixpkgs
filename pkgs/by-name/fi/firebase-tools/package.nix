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
  version = "14.1.0";

  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-tools";
    tag = "v${version}";
    hash = "sha256-7yxDBK3A2Yosp/83JmFpV3cm+YEDxHMLVj5B+rwSIR8=";
  };

  npmDepsHash = "sha256-r6vonG5edL/nTtyj8uXc/4w2xgihRce/Md+umxomTzo=";

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
