{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  python3,
  xcbuild,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "firebase-tools";
  version = "15.15.0";
  nodejs = nodejs_22;

  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-tools";
    tag = "v${version}";
    hash = "sha256-lY52YRT+DIV8DTIEtquRuB6Q6TY0mi4I4+E+o1usQrM=";
  };

  npmDepsHash = "sha256-7XYgjoKEHXi26utNECCjqaDXoWYcyblt7rGgklWbmX8=";

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
