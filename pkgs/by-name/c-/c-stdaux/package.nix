{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "c-stdaux";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "c-util";
    repo = "c-stdaux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/15lop+WUkTW9v9h7BBdwRSpJgcBXaJNtMM7LXgcQE4=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/c-util/c-stdaux";
    description = "Auxiliary macros and functions for the C standard library";
    changelog = "https://github.com/c-util/c-stdaux/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      lgpl2Plus
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
