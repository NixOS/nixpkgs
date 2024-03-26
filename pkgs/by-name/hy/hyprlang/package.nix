{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlang";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlang";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bR4o3mynoTa1Wi4ZTjbnsZ6iqVcPGriXp56bZh5UFTk=";
  };

  nativeBuildInputs = [
    cmake
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/hyprwm/hyprlang";
    description = "The official implementation library for the hypr config language";
    license = licenses.lgpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ iogamaster fufexan ];
  };
})
