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
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-panel-spacer-extended";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-wjt/N4vRt7AmchAWRwvdG+9Lu7t+j5PxJKrULlvGHtE=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.kdeplasma-addons
    kdePackages.plasma-desktop
  ];

  cmakeFlags = [ "-DQt6_DIR=${kdePackages.qtbase}/lib/cmake/Qt6" ];

  propagatedUserEnvPkgs = [ glib ];

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spacer with Mouse gestures for the KDE Plasma Panel featuring Latte Dock/Gnome/Unity drag window gesture. Run any shortcut, command, application or URL/file with up to ten configurable mouse actions";
    homepage = "https://github.com/luisbocanegra/plasma-panel-spacer-extended";
    changelog = "https://github.com/luisbocanegra/plasma-panel-spacer-extended/blob/main/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
