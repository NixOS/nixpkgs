{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlang";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlang";
    rev = "v${finalAttrs.version}";
    hash = "sha256-upV2PWOoQ5hKbeuMwiJ4RJUa1JDVqzxdr5LL7YJJ/f4=";
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
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ iogamaster fufexan ];
  };
})
