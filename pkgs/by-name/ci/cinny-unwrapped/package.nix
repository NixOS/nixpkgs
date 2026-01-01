{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  giflib,
  python3,
  pkg-config,
  pixman,
<<<<<<< HEAD
  nodejs_22,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cairo,
  pango,
  stdenv,
}:

buildNpmPackage rec {
  pname = "cinny-unwrapped";
  version = "4.10.2";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    tag = "v${version}";
    hash = "sha256-RPFEquxMRnNW+L6azcDmrIKXG27DAF2PxDmSB3ErOHk=";
  };

<<<<<<< HEAD
  nodejs = nodejs_22;

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  npmDepsHash = "sha256-h4Ipmmo0Jf6/rzCAKtLLCYrUi1anVKZSgy/kcEKDQJg=";

  nativeBuildInputs = [
    python3
    pkg-config
  ];

  buildInputs = [
    pixman
    cairo
    pango
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ giflib ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  meta = {
    description = "Yet another Matrix client for the web";
    homepage = "https://cinny.in/";
    maintainers = with lib.maintainers; [ abbe ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
  };
}
