{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  aquamarine,
  cairo,
  hyprgraphics,
  hyprlang,
  hyprtoolkit,
  hyprutils,
  hyprwire,
  libdrm,
  libqalculate,
  libxkbcommon,
  pixman,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlauncher";
<<<<<<< HEAD
  version = "0.1.4";
=======
  version = "0.1.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlauncher";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-slOlmNtNSqtVvmkZErkwFjGxsLioDUp0l1xXt+g8ggo=";
=======
    hash = "sha256-KMqHEAuRfO4ep40jxsGW6mnJSeWM41qv63KbWcLBfuw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    aquamarine
    cairo
    hyprgraphics
    hyprlang
    hyprtoolkit
    hyprutils
    hyprwire
    libdrm
    libqalculate
    libxkbcommon
    pixman
  ];

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "A multipurpose and versatile launcher / picker for Hyprland";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    platforms = with lib.platforms; linux ++ freebsd;
    mainProgram = "hyprlauncher";
  };
})
