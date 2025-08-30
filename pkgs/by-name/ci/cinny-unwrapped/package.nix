{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  giflib,
  python3,
  pkg-config,
  pixman,
  cairo,
  pango,
  stdenv,
}:

buildNpmPackage rec {
  pname = "cinny-unwrapped";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    tag = "v${version}";
    hash = "sha256-tvBaONJwfkCK77aHmWJ/UAAZHq2WIc7geNT2tEFKuZ0=";
  };

  npmDepsHash = "sha256-9faffTlXEI1lMrVrkSyso/tfjs/4W+TVzmiv+bZAv18=";

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
