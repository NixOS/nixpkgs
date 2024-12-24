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
  olm,
  nodejs_20,
}:

buildNpmPackage rec {
  pname = "cinny-unwrapped";
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    rev = "v${version}";
    hash = "sha256-BoUQURCfEu5kocMm8T25cVl8hgZGxcxrMzQZOl2fAbY=";
  };

  # canvas, a transitive dependency of cinny, fails to build with Node 22
  # https://github.com/Automattic/node-canvas/issues/2448
  nodejs = nodejs_20;

  npmDepsHash = "sha256-fDoia6evCmXZgeIKL0coRo3yunX1dfud31ROgmop2Sc=";

  # Fix error: no member named 'aligned_alloc' in the global namespace
  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.hostPlatform.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinSdkVersion "11.0"
  ) "-D_LIBCPP_HAS_NO_LIBRARY_ALIGNED_ALLOCATION=1";

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
    inherit (olm.meta) knownVulnerabilities;
  };
}
