{
  lib,
  stdenv,
  fetchFromGitHub,

  # native
  autoreconfHook,
  glibcLocales,
  pkg-config,

  # host
  curl,
  glib,
  id3lib,
  libxml2,
  taglib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "castget";
  # Using unstable version since it doesn't require `ronn`, see:
  # https://github.com/mlj/castget/commit/e97b179227b4fc7e2e2bc5a373933624c0467daa
  version = "2.0.1-unstable-2025-01-25";

  src = fetchFromGitHub {
    owner = "mlj";
    repo = "castget";
    rev = "e97b179227b4fc7e2e2bc5a373933624c0467daa";
    hash = "sha256-3t/N8JO36wjHuzIdWNstRWphC/ZR6KkZX0l9yKarS7c=";
  };

  # without this, the build fails because of an encoding issue with the manual page.
  # https://stackoverflow.com/a/17031697/4935114
  # This requires glibcLocales to be present in the build so it will have an impact.
  # See https://github.com/NixOS/nixpkgs/issues/8398
  preBuild = ''
    export LC_ALL="en_US.UTF-8";
  '';

  buildInputs = [
    curl
    glib
    id3lib
    libxml2
    taglib
  ];
  nativeBuildInputs = [
    autoreconfHook
    # See comment on locale above
    glibcLocales
    pkg-config
  ];

  meta = {
    description = "Simple, command-line based RSS enclosure downloader";
    mainProgram = "castget";
    longDescription = ''
      castget is a simple, command-line based RSS enclosure downloader. It is
      primarily intended for automatic, unattended downloading of podcasts.
    '';
    homepage = "https://castget.johndal.com/";
    changelog = "https://github.com/mlj/castget/blob/${finalAttrs.version}/CHANGES.md";
    maintainers = with lib.maintainers; [ doronbehar ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
