{
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  cmake,
  man,
  groff,
  xdg-utils,
  fetchFromGitHub,
  cogapp,
  ncurses,
  zlib,
  bzip2,
  xz,
  cunit,
  nix-update-script,
  versionCheckHook,
  testers,
  qman,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qman";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "plp13";
    repo = "qman";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pgxRk3XSR+pqPlfL65BTLI3vvGTP0GooT5ovompbx7E=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    cmake
    cogapp
  ];

  buildInputs = [
    ncurses
    zlib
    bzip2
    xz
    cunit
  ];

  # https://github.com/plp13/qman/blob/main/doc/BUILDING.md#meson-options
  mesonFlags = [
    (lib.mesonEnable "man-pages" true)
    (lib.mesonEnable "gzip" true)
    (lib.mesonEnable "bzip2" true)
    (lib.mesonEnable "lzma" true)
    (lib.mesonEnable "tests" true)
    (lib.mesonEnable "docs" false)
    (lib.mesonEnable "config" false)
  ];

  postPatch = ''
    # qman uses absolute path lookups to find external programs such as `man`
    # instead of traversing $PATH.
    # https://github.com/plp13/qman/blob/v1.5.0/src/config_def.py#L180-L186
    substituteInPlace ./src/config_def.py \
      --replace-fail /usr/bin/man ${man}/bin/man \
      --replace-fail /usr/bin/whatis ${man}/bin/whatis \
      --replace-fail /usr/bin/apropos ${man}/bin/apropos \
      --replace-fail /usr/bin/groff ${groff}/bin/groff \
      --replace-fail /usr/bin/xdg-open ${xdg-utils}/bin/xdg-open \
      --replace-fail /usr/bin/xdg-email ${xdg-utils}/bin/xdg-email

    patchShebangs ./src/qman_tests_list.sh
  '';

  doCheck = true;

  doInstallCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = qman; };
  };

  meta = {
    description = "Modern TUI man page viewer";
    homepage = "https://github.com/plp13/qman";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.kpbaks ];
    mainProgram = "qman";
  };
})
