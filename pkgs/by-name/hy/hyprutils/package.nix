{
  lib,
<<<<<<< HEAD
  gcc15Stdenv,
=======
  stdenv,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cmake,
  pkg-config,
  pixman,
  fetchFromGitHub,
  nix-update-script,
}:

<<<<<<< HEAD
gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprutils";
  version = "0.11.0";
=======
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprutils";
  version = "0.10.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprutils";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-rGbEMhTTyTzw4iyz45lch5kXseqnqcEpmrHdy+zHsfo=";
=======
    hash = "sha256-XQLlR/QJWiRRWY+ohtOqfe0fDMMPl/UyQCcypfUtZiE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    pixman
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeBuildType = "RelWithDebInfo";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/hyprwm/hyprutils";
    description = "Small C++ library for utilities used across the Hypr* ecosystem";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    teams = [ lib.teams.hyprland ];
    maintainers = with lib.maintainers; [ logger ];
  };
})
