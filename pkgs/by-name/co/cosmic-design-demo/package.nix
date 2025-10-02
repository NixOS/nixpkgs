{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  libcosmicAppHook,
  expat,
  fontconfig,
  freetype,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-design-demo";
  version = "0-unstable-2024-01-08";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-design-demo";
    rev = "d58cfad46f2982982494fce27fb00ad834dc8992";
    hash = "sha256-nWkiaegSjxgyGlpjXE9vzGjiDORaRCSoZJMDv0jtvaA=";
  };

  cargoHash = "sha256-czfDtiSEmzmcLfpqv0/8sP8zDAEKh+pkQkGXdd5NskM=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
  ];

  buildInputs = [
    expat
    fontconfig
    freetype
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--unstable"
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-design-demo"
  ];

  meta = {
    homepage = "https://github.com/pop-os/cosmic-design-demo";
    description = "Design Demo for the COSMIC Desktop Environment";
    license = lib.licenses.mpl20;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-design-demo";
  };
}
