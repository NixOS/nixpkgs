{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "c-stdaux";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "c-util";
    repo = "c-stdaux";
    tag = "v${version}";
    hash = "sha256-MsnuEyVCmOIr/q6I1qyPsNXp48jxIEcXoYLHbOAZtW0=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/c-util/c-stdaux";
    description = "Auxiliary macros and functions for the C standard library";
    changelog = "https://github.com/c-util/c-stdaux/releases/tag/${src.tag}";
    license = with lib.licenses; [
      asl20
      lgpl2Plus
    ];
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
