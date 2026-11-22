{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  pkg-config,
  fcitx5,
  m17n_lib,
  m17n_db,
  gettext,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-m17n";
  version = "5.1.8";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-jjwgTC1B+9fhvj0nau/pkA4l4gAzSTCSf+a9u5Kq3jA=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    pkg-config
    gettext
  ];

  buildInputs = [
    kdePackages.extra-cmake-modules
    fcitx5
    m17n_db
    m17n_lib
  ];

  strictDeps = true;
  __structuredAttrs = true;

  passthru.tests = {
    inherit (nixosTests) fcitx5;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "m17n support for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-m17n";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      Technical27
      Holiu618
    ];
    platforms = lib.platforms.linux;
  };
})
