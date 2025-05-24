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
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    tag = "v${version}";
    hash = "sha256-yM+P7KXT/cspKt2l4+COoH68jCJUSs2TrfJGZHF/lYY=";
  };

  npmDepsHash = "sha256-RWc8nSh/HuXUokU2RZnmwYUCfBxpL9Wp1Sgi2l1CN38=";

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
