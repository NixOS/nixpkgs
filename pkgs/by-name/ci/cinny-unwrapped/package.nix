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
  version = "4.10.0";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    tag = "v${version}";
    hash = "sha256-KpN6ul+kzGarBKnXXSP3gf9KlRII869xnfT95mzacRc=";
  };

  npmDepsHash = "sha256-N5xHu4AmgRdd3gM+YTu+fbtAw1YDp4SMXdXUbbJnIZc=";

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
