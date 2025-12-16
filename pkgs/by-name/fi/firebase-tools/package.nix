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
  version = "15.0.0";

  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-tools";
    tag = "v${version}";
    hash = "sha256-5bxcocw20zzjEh5kGLEUMW/xuAaAvX1goYP5JesFfm0=";
  };

  npmDepsHash = "sha256-a46vqu39pVKpu1kpP7+EiYUg2DK/fHTWTX+qZ1j+744=";

  # No more package-lock.json in upstream src
  postPatch = ''
    cp ./npm-shrinkwrap.json ./package-lock.json
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
