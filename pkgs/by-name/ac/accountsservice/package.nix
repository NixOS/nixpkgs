{
  lib,
  stdenv,
  fetchFromGitLab,
  replaceVars,
  pkg-config,
  glib,
  shadow,
  gobject-introspection,
  polkit,
  systemdLibs,
  meson,
  mesonEmulatorHook,
  dbus,
  json_c,
  ninja,
  python3,
  vala,
  gettext,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "accountsservice";
  version = "26.26.9";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "accountsservice";
    repo = "accountsservice";
    tag = finalAttrs.version;
    hash = "sha256-Q3/atkTRJ5Dzps1+zNxnWGaLnkOSMg+i7hzEMmhk6XI=";
  };

  patches = [
    # Hardcode dependency paths.
    (replaceVars ./fix-paths.patch {
      inherit shadow;
    })

    # Do not try to create directories in /var, that will not work in Nix sandbox.
    ./no-create-dirs.patch

    # Disable mutating D-Bus methods with immutable /etc.
    ./Disable-methods-that-change-files-in-etc.patch

    # Do not ignore third-party (e.g Pantheon) extensions not matching FHS path scheme.
    # Fixes https://github.com/NixOS/nixpkgs/issues/72396
    ./drop-prefix-check-extensions.patch

    # Detect DM type from config file.
    # `readlink display-manager.service` won't return any of the candidates.
    ./get-dm-type-from-config.patch
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    vala
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    #  meson.build:88:2: ERROR: Can not run test applications in this cross environment.
    mesonEmulatorHook
  ];

  buildInputs = [
    dbus
    gettext
    glib
    json_c
    polkit
    systemdLibs
    libxcrypt
  ];

  env =
    lib.optionalAttrs (stdenv.cc.isGNU && (lib.versionAtLeast (lib.getVersion stdenv.cc.cc) "14"))
      {
        NIX_CFLAGS_COMPILE = toString [
          "-Wno-error=deprecated-declarations"
          "-Wno-error=implicit-function-declaration"
          "-Wno-error=return-mismatch"
        ];
      };

  mesonFlags = [
    "-Dadmin_group=wheel"
    "-Dlocalstatedir=/var"
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py

    substituteInPlace meson.build \
      --replace-fail "run_command(['./generate-version.sh'], check: true).stdout().strip()" "'${finalAttrs.version}'"
  '';

  meta = {
    changelog = "https://gitlab.freedesktop.org/accountsservice/accountsservice/-/releases/${finalAttrs.src.tag}";
    description = "D-Bus interface for user account query and manipulation";
    homepage = "https://www.freedesktop.org/wiki/Software/AccountsService";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pSub ];
    teams = with lib.teams; [ freedesktop ];
    platforms = lib.platforms.linux;
  };
})
