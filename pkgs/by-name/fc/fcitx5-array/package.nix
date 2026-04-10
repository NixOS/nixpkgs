{
  lib,
  stdenv,
  fetchFromGitHub,
  fmt,
  cmake,
  extra-cmake-modules,
  gettext,
  fcitx5,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-array";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "ray2501";
    repo = "fcitx5-array";
    tag = finalAttrs.version;
    hash = "sha256-YDFT/CawFiPN3kXzHMpenCzWMJSA1dFUhVe22EDfnU8=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
  ];

  buildInputs = [
    fmt
    fcitx5
    sqlite
  ];

  strictDeps = true;

  meta = {
    description = "Array wrapper for Fcitx5";
    homepage = "https://github.com/ray2501/fcitx5-array";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ yanganto ];
    platforms = lib.platforms.linux;
  };
})
