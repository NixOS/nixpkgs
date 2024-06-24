{
  lib,
  stdenv,
  cmake,
  pkg-config,
  pixman,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprutils";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprutils";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-CqRZne63BpYlPd/i8lXV0UInUt59oKogiwdVtBRHt60=";
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
