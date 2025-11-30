{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  ncurses,
  zlib,
  bzip2,
  xz,
  cunit,
  man,
  groff,
  xdg-utils,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qman";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "plp13";
    repo = "qman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pgxRk3XSR+pqPlfL65BTLI3vvGTP0GooT5ovompbx7E=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3.pkgs.cogapp
  ];

  buildInputs = [
    ncurses
    zlib
    bzip2
    xz
    cunit
  ];

  propagatedUserEnvPkgs = [
    man
    groff
    xdg-utils
  ];

  postPatch = ''
    patchShebangs src/qman_tests_list.sh

    substituteInPlace src/config_def.py \
      --replace-fail '/usr/bin/man' '${lib.getExe' man "man"}' \
      --replace-fail '/usr/bin/groff' '${lib.getExe' groff "groff"}' \
      --replace-fail '/usr/bin/whatis' '${lib.getExe' man "whatis"}' \
      --replace-fail '/usr/bin/apropos' '${lib.getExe' man "apropos"}' \
      --replace-fail '/usr/bin/xdg-open' '${lib.getExe' xdg-utils "xdg-open"}' \
      --replace-fail '/usr/bin/xdg-email' '${lib.getExe' xdg-utils "xdg-email"}'

    substituteInPlace {man/qman.1,doc/TROUBLESHOOTING.md} \
      --replace-fail '/usr/bin' '/run/current-system/sw/bin'
  '';

  mesonFlags = [ "-Dconfigdir=${placeholder "out"}/etc/xdg/qman" ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "qman --version";
    };
  };

  meta = {
    description = "Modern man page viewer";
    homepage = "https://github.com/plp13/qman";
    license = lib.licenses.bsd2;
    mainProgram = "qman";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      yiyu
      kpbaks
    ];
  };
})
