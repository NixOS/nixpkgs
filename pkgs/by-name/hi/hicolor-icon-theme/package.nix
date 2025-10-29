{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  testers,
  meson,
  pkg-config,
  ninja,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hicolor-icon-theme";
  version = "0.18";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = "default-icon-theme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uoB7u/ok7vMxKDl8pINdnV9VsvmsntBcZuz3Q4zGz7M=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  setupHook = ./setup-hook.sh;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Default fallback theme used by implementations of the icon theme specification";
    homepage = "https://www.freedesktop.org/wiki/Software/icon-theme/";
    changelog = "https://gitlab.freedesktop.org/xdg/default-icon-theme/-/blob/${finalAttrs.src.rev}/NEWS";
    platforms = platforms.unix;
    license = licenses.gpl2Only;
    pkgConfigModules = [ "default-icon-theme" ];
    maintainers = with maintainers; [ jopejoe1 ];
  };
})
