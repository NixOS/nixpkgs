{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  xcbuild,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "firebase-tools";
  version = "15.37.0";

  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xwRCIqYyFEUZXCSfH4MKEKPJK5Xsulnk/REe81yz830=";
  };

  npmDepsFetcherVersion = 2;

  npmDepsHash = "sha256-uakZxFK2KAdGqpz9e8tJDY0yEHcN6maegVLBvEtpdBQ=";

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
    changelog = "https://github.com/firebase/firebase-tools/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Manage, and deploy your Firebase project from the command line";
    homepage = "https://github.com/firebase/firebase-tools";
    license = lib.licenses.mit;
    mainProgram = "firebase";
    maintainers = with lib.maintainers; [
      sarahec
    ];
  };
})
