{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
}:

stdenv.mkDerivation rec {
  pname = "opencloud-desktop-shell-integration-resources";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "desktop-shell-integration-resources";
    tag = "v${version}";
    hash = "sha256-TqJanrAKD3aNQu5jL1Dt0bn84dYBNGImAKBGsAY2xeU=";
  };

  buildInputs = [
    kdePackages.extra-cmake-modules
  ];

  nativeBuildInputs = [
    cmake
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Shared assets for OpenCloud desktop shell integrations";
    homepage = "https://github.com/opencloud-eu/desktop-shell-integration-resources";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ k900 ];
    platforms = lib.platforms.all;
  };
}
