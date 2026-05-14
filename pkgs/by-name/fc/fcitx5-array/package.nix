{
  lib,
  stdenv,
  fetchFromGitHub,
  fmt,
  cmake,
  kdePackages,
  gettext,
  fcitx5,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-array";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ray2501";
    repo = "fcitx5-array";
    tag = finalAttrs.version;
    hash = "sha256-IIsmldCqXgVJZXS0GcxxYiwpuqPw0GdABvk94q850pQ=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    gettext
  ];

  buildInputs = [
    kdePackages.extra-cmake-modules
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
