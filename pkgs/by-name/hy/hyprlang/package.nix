{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlang";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlang";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Jq9hHYFL5nMHArWgJIcrDHGnzs/MjDi95cyB7cUZIJ4=";
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
