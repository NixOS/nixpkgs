{
  fetchFromGitHub,
  lib,
  meson,
  ninja,
  nix-update-script,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frog-protocols";
  version = "0.01-unstable-2024-09-25";

  src = fetchFromGitHub {
    owner = "misyltoad";
    repo = "frog-protocols";
    rev = "17be81da707722b4f907c5287def442351b219b0";
    hash = "sha256-N8a+o5I7CRoONCvjMHVmPkJTVncczuFVRHEtMFzMzss=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Wayland protocols but much more iterative";
    homepage = "https://github.com/misyltoad/frog-protocols";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      getchoo
      Scrumplex
    ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "frog-protocols" ];
  };
})
