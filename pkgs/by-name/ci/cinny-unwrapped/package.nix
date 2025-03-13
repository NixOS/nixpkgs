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
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    rev = "v${version}";
    hash = "sha256-uwazJSd9I80ExKv22Ycg/fBDGZ1GuW4pcBo83lUwhoc=";
  };

  npmDepsHash = "sha256-o5txGbuNl+ZMk5acu/0/5CTNTvdP+Tqyw7heFRaZ4lM=";

  nativeBuildInputs = [
    python3
    pkg-config
  ];

  buildInputs = [
    pixman
    cairo
    pango
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ giflib ];

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
