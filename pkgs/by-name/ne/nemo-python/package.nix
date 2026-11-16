{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  glib,
  gtk3,
  nemo,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nemo-python";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    rev = finalAttrs.version;
    hash = "sha256-tXeMkaCYnWzg+6ng8Tyg4Ms1aUeE3xiEkQ3tKEX6Vv8=";
  };

  sourceRoot = "${finalAttrs.src.name}/nemo-python";

  patches = [
    # Load extensions from NEMO_PYTHON_EXTENSION_DIR environment variable
    # https://github.com/NixOS/nixpkgs/issues/78327
    ./load-extensions-from-env.patch

    # Pick up all passthru.nemoPythonExtensionDeps via nemo-with-extensions wrapper
    ./python-path.patch
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    glib
    gtk3
    nemo
    python3
    python3.pkgs.pygobject3
  ];

  postPatch = ''
    # Tries to load libpython3.so via g_module_open ().
    substituteInPlace meson.build \
      --replace "get_option('prefix'), get_option('libdir')" "'${python3}/lib'"
  '';

  env.PKG_CONFIG_LIBNEMO_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/${nemo.extensiondir}";

  passthru.nemoPythonExtensionDeps = [ python3.pkgs.pygobject3 ];

  meta = {
    homepage = "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-python";
    description = "Python bindings for the Nemo extension library";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
