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

  meta = {
    homepage = "https://github.com/hyprwm/hyprlang";
    description = "Official implementation library for the hypr config language";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      iogamaster
      fufexan
    ];
  };
})
