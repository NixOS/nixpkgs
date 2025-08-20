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
    rev = "38db7e30e62a988f701a2751447e0adffd68bb3f";
    hash = "sha256-daWGw6mRmiz6f81JkMacPipXppRxbjL6gS1VqYlfec8=";
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
