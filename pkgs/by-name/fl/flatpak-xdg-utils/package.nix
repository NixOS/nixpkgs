{
  lib,
  fetchFromGitHub,
  glib,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flatpak-xdg-utils";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "flatpak-xdg-utils";
    tag = finalAttrs.version;
    hash = "sha256-j5A5msgKjQSIvCvFSZGL8QfwH+SJGJ4S3PPCHOmM/bk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/flatpak/flatpak-xdg-utils/releases/tag/${finalAttrs.version}";
    description = "Commandline utilities for use inside Flatpak sandboxes";
    homepage = "https://flatpak.org/";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ michaelgrahamevans ];
    platforms = lib.platforms.linux;
  };
})
