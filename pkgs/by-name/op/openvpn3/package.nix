{
  lib,
  stdenv,
  fetchFromGitHub,
  asio_1_32_0,
  glib,
  jsoncpp,
  libcap_ng,
  libnl,
  libuuid,
  lz4,
  openssl,
  pkg-config,
  protobuf,
  python3,
  systemd,
  tinyxml-2,
  wrapGAppsHook3,
  gobject-introspection,
  meson,
  ninja,
  gdbuspp,
  cmake,
  git,
  nix-update-script,
  enableSystemdResolved ? true,
}:

stdenv.mkDerivation rec {
  pname = "openvpn3";
  version = "25";

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "openvpn3-linux";
    tag = "v${version}";
    hash = "sha256-Fme8OT49h2nZw5ypyeKdHlqv2Hk92LW2KVisd0jC66s=";
    # `openvpn3-core` is a submodule.
    # TODO: make it into a separate package
    fetchSubmodules = true;
  };

  patches = [
    # Should be fixed in v26: https://codeberg.org/OpenVPN/openvpn3-linux/issues/70
    ./v25-latest-linux-fix.patch
  ];

  postPatch = ''
    echo '#define OPENVPN_VERSION "3.git:unknown:unknown"
    #define PACKAGE_GUIVERSION "v${builtins.replaceStrings [ "_" ] [ ":" ] version}"
    #define PACKAGE_NAME "openvpn3-linux"
    ' > ./src/build-version.h

    patchShebangs \
      ./scripts \
      ./src/python/{openvpn2,openvpn3-as,openvpn3-autoload} \
      ./distro/systemd/openvpn3-systemd \
      ./src/tests/dbus/netcfg-subscription-test \
      ./src/shell/bash-completion/gen-openvpn2-completion.py
  '';

  pythonPath = python3.withPackages (ps: [
    ps.dbus-python
    ps.pygobject3
    ps.systemd-python
  ]);

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    git

    python3.pkgs.wrapPython
    python3.pkgs.docutils
    python3.pkgs.jinja2
    python3.pkgs.dbus-python
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    # Depends on io_service
    asio_1_32_0
    glib
    jsoncpp
    libcap_ng
    libnl
    libuuid
    lz4
    openssl
    protobuf
    tinyxml-2
    gdbuspp
  ]
  ++ lib.optionals enableSystemdResolved [ systemd.dev ];

  mesonFlags = [
    (lib.mesonOption "selinux" "disabled")
    (lib.mesonOption "selinux_policy" "disabled")
    (lib.mesonOption "bash-completion" "enabled")
    (lib.mesonOption "test_programs" "disabled")
    (lib.mesonOption "unit_tests" "disabled")
    (lib.mesonOption "asio_path" "${asio_1_32_0}")
    (lib.mesonOption "dbus_policy_dir" "${placeholder "out"}/share/dbus-1/system.d")
    (lib.mesonOption "dbus_system_service_dir" "${placeholder "out"}/share/dbus-1/system-services")
    (lib.mesonOption "systemd_system_unit_dir" "${placeholder "out"}/lib/systemd/system")
    (lib.mesonOption "create_statedir" "false")
    (lib.mesonOption "sharedstatedir" "/etc")
  ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  postFixup = ''
    wrapPythonPrograms
    wrapPythonProgramsIn "$out/libexec/openvpn3-linux" "$out ${pythonPath}"
  '';

  NIX_LDFLAGS = "-lpthread";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenVPN 3 Linux client";
    license = lib.licenses.agpl3Plus;
    homepage = "https://github.com/OpenVPN/openvpn3-linux/";
    changelog = "https://github.com/OpenVPN/openvpn3-linux/releases/tag/v${version}";
    maintainers = with lib.maintainers; [
      shamilton
      progrm_jarvis
    ];
    platforms = lib.platforms.linux;
  };
}
