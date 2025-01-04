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
  version = "13.29.1";
  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-tools";
    tag = "v${version}";
    hash = "sha256-j6luT+L/vN9qaGjjeMW+8QGuzjJxzbn0sMGDjhqoeZA=";
  };
in
buildNpmPackage {
  pname = "firebase-tools";
  inherit version src;

  npmDepsHash = "sha256-lQmoemIxzy2biu80UTR2eA+KJBeXWPh0xZRs/1of0eo=";

  patches = [
    # Use modern version of `ajv` instead of the four year old default in 13.29.1
    (fetchpatch {
      name = "bump-ajv.patch";
      url = "https://github.com/firebase/firebase-tools/commit/b684155d827e7d1e8390e22511c0e1b5c46812ef.patch";
      hash = "sha256-yv2AknT85Eyurc1ZFbbF5S9Sj/VEaVnHXBcXI10OWpw=";
    })
    # Fix embedded nan version to support node 22
    ./001-override-nan.patch
  ];

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
