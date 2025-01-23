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
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-panel-spacer-extended";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rr80bI+9xnrlj8JNTL+vGqOw9/98R0ub0pQfHQmEWNM=";
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
