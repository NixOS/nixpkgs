{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  asio_1_32_0,
  glib,
  fmt_11,
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
  unzip,
  enableSystemdResolved ? true,
}:
let
  # Derived from subprojects/fmt.wrap
  libfmt-meson-patch = fetchurl {
    url = "https://wrapdb.mesonbuild.com/v2/fmt_11.2.0-1/get_patch";
    hash = "sha256-ZFvxwzWiRgi0s08W7RC5I3u7ATFIhmj7hkVCAiOeCGw=";
  };
in
stdenv.mkDerivation rec {
  pname = "openvpn3";
  version = "27";

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "openvpn3-linux";
    tag = "v${version}";
    hash = "sha256-H+QF0Z1IUKx2U0+V7KHaAd/AKbuJEKLIwqyK2srD8DM=";
    # `openvpn3-core` is a submodule.
    # TODO: make it into a separate package
    fetchSubmodules = true;
  };

  patches = [
    ./0001-handle-result-from-DcoKeyConfig_ParseFromString.patch
  ];

  prePatch = ''
    cp -r ${fmt_11.src} subprojects/fmt-11.2.0
    chmod +w -R subprojects/fmt-11.2.0 # Allow patches for subprojects to work
    tmp=$(mktemp -d)
    unzip ${libfmt-meson-patch} -d $tmp
    cp -r $tmp/*/* subprojects/fmt-11.2.0
  '';

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
    unzip

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
    (lib.mesonOption "systemd_user_unit_dir" "${placeholder "out"}/lib/systemd/user")
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

  env.NIX_LDFLAGS = "-lpthread";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenVPN 3 Linux client";
    license = lib.licenses.agpl3Plus;
    homepage = "https://github.com/OpenVPN/openvpn3-linux/";
    changelog = "https://github.com/OpenVPN/openvpn3-linux/releases/tag/v${version}";
    maintainers = with lib.maintainers; [
      progrm_jarvis
    ];
    platforms = lib.platforms.linux;
  };
}
