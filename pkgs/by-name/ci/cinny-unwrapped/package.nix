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
  version = "4.8.1";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    tag = "v${version}";
    hash = "sha256-1F49KHAfCtvcqMeRYI8r6Ke7oz+EQqOfkgdgn5E1DU4=";
  };

  npmDepsHash = "sha256-Tx+08NrbFolI7agC6AtNvkOgCJWJa4fsY0CFC02h4r0=";

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
