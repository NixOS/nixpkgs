{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  glib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-panel-spacer-extended";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-panel-spacer-extended";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-3ediynClboG6/dBQTih6jJPGjsTBZhZKOPQAjGLRNmk=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
  ];

  buildInputs = [
    kdePackages.kdeplasma-addons
    kdePackages.plasma-desktop
  ];

  strictDeps = true;

  cmakeFlags = [ (lib.cmakeFeature "Qt6_DIR" "${kdePackages.qtbase}/lib/cmake/Qt6") ];

  propagatedUserEnvPkgs = [ glib ];

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spacer with mouse gestures for the KDE Plasma Panel";
    homepage = "https://github.com/luisbocanegra/plasma-panel-spacer-extended";
    changelog = "https://github.com/luisbocanegra/plasma-panel-spacer-extended/blob/main/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
