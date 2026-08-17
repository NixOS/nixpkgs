{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  json-glib,
  feedbackd,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "feedbackd-device-themes";
  version = "0.8.8";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "agx";
    repo = "feedbackd-device-themes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EZpzqEhUeqqe96qcfKyvhQodBTcsgwNZyXvk2zHj20k=";
  };

  nativeBuildInputs = [
    meson
    ninja
    json-glib # Provides json-glib-validate
  ];

  nativeCheckInputs = [
    feedbackd # Provides fbd-theme-validate
  ];

  mesonFlags = [
    (lib.mesonOption "validate" (if finalAttrs.doCheck then "enabled" else "disabled"))
  ];

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  strictDeps = true;

  meta = {
    description = "Device specific feedback themes for Feedbackd";
    homepage = "https://gitlab.freedesktop.org/agx/feedbackd-device-themes";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      pacman99
      Luflosi
    ];
    platforms = lib.platforms.linux;
  };
})
