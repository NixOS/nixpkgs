{
  lib,
  stdenv,
  fetchFromGitHub,
  runtimeShell,
  man-db,
  groff,
  xdg-utils,
  meson,
  ninja,
  pkg-config,
  cmake,
  python3Packages,
  ncurses,
  zlib,
  bzip2,
  xz,
  cunit,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qman";
  version = "1.5.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "plp13";
    repo = "qman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z3ILbbwcCYZT8qabVaGnMCyZRag8djEI32i6G7cLL2A=";
  };

  postPatch = ''
    substituteInPlace src/qman_tests_list.sh \
      --replace-fail "/usr/bin/env bash" ${runtimeShell}
    substituteInPlace src/config_def.py \
      --replace-fail "/usr/bin/man" ${man-db}/bin/man \
      --replace-fail "/usr/bin/groff" ${groff}/bin/groff \
      --replace-fail "/usr/bin/whatis" ${man-db}/bin/whatis \
      --replace-fail "/usr/bin/apropos" ${man-db}/bin/apropos \
      --replace-fail "/usr/bin/xdg-open" ${xdg-utils}/bin/xdg-open \
      --replace-fail "/usr/bin/xdg-email" ${xdg-utils}/bin/xdg-email
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    python3Packages.cogapp
  ];

  buildInputs = [
    ncurses
    zlib
    bzip2
    xz
    cunit
  ];

  mesonFlags = [
    "-Dconfigdir=${placeholder "out"}/etc/xdg/qman"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A more modern man page viewer for our terminals";
    homepage = "https://github.com/plp13/qman";
    changelog = "https://github.com/plp13/qman/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pborzenkov ];
    mainProgram = "qman";
    platforms = lib.platforms.all;
  };
})
