{
  lib,
  stdenv,
  cmake,
  pkg-config,
  pixman,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprutils";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprutils";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-dmRz128j/lJmMuTYeCYPfSBRHHQO3VeH4PbmoyAhHzw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    pixman
  ];

  outputs = ["out" "dev"];

  cmakeBuildType = "RelWithDebInfo";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/hyprwm/hyprutils";
    description = "Small C++ library for utilities used across the Hypr* ecosystem";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers =  with lib.maintainers; [
      donovanglover
      johnrtitor
    ];
  };
})
