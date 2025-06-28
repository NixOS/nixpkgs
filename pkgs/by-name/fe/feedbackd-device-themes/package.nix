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
  version = "0.8.3";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "agx";
    repo = "feedbackd-device-themes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z+A2G1g2gNfC0cVWUO/LT3QVvXeotcBd+5UEpEtcPfY=";
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

  meta = with lib; {
    description = "Device specific feedback themes for Feedbackd";
    homepage = "https://gitlab.freedesktop.org/agx/feedbackd-device-themes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      pacman99
      Luflosi
    ];
    platforms = platforms.linux;
  };
})
