{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  xcbuild,
}:
buildNpmPackage rec {
  pname = "firebase-tools";
  version = "13.31.2";

  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-tools";
    tag = "v${version}";
    hash = "sha256-Oyg559MT5+F8QKfPqNgKq8fXtn4hnZeO1ipgkYuMgNE=";
  };

  npmDepsHash = "sha256-mJ+H7rG9quBZWklb2dYlJ3uBa2SmDME517TbcJ/Gnvc=";

  patches = [
    ./override-ajv.patch
    ./override-whatwg-url.patch
  ];

  postPatch = ''
    ln -s npm-shrinkwrap.json package-lock.json
  '';

  makeCacheWritable = true;

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
