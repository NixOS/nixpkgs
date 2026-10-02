{
  lib,
  stdenv,
  fetchpatch,
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
stdenv.mkDerivation (finalAttrs: {
  pname = "openvpn3";
  version = "27.1";

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "openvpn3-linux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Egt6lVcvlmxnABw4v0cdROQzVdkA3DgOGGCSgl+QFdM=";
    # `openvpn3-core` is a submodule.
    # TODO: make it into a separate package
    fetchSubmodules = true;
  };

  patches = [
    ./0001-handle-result-from-DcoKeyConfig_ParseFromString.patch
    (fetchpatch {
      # Require C++20 for abseil-cpp 202608.
      url = "https://github.com/OpenVPN/openvpn3-linux/commit/f6b84daf83ef507a78ca4af32bf4a55470ba0043.patch";
      hash = "sha256-8AYvw6p4hw7gP9ROzjPNpsuEZtbw5c5z2goV5+arHa4=";
    })
    (fetchpatch {
      # Avoid C++20 mixed-enum bitwise warnings.
      url = "https://github.com/OpenVPN/openvpn3/commit/f3e7d10dfb787de592a3b50bbe47b8a421c8d185.patch";
      hash = "sha256-8h+eIW+d4hCgJOYQzI/XOpVmhy4ojmxzzf5Hm3LcSTs=";
      extraPrefix = "openvpn3-core/";
      stripLen = 1;
    })
    (fetchpatch {
      # Avoid C++20 mixed-enum arithmetic warnings.
      url = "https://github.com/OpenVPN/openvpn3/commit/11ab894befb781a3c255e64a53571f2fd697bdfe.patch";
      hash = "sha256-Dv2lOnxwZD7f2/6eauA60Q4qp+q/An/+B6Il4uHXhzU=";
      extraPrefix = "openvpn3-core/";
      stripLen = 1;
    })
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
    #define PACKAGE_GUIVERSION "v${builtins.replaceStrings [ "_" ] [ ":" ] finalAttrs.version}"
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
    wrapPythonProgramsIn "$out/libexec/openvpn3-linux" "$out ${finalAttrs.pythonPath}"
  '';

  env.NIX_LDFLAGS = "-lpthread";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenVPN 3 Linux client";
    license = lib.licenses.agpl3Plus;
    homepage = "https://github.com/OpenVPN/openvpn3-linux/";
    changelog = "https://github.com/OpenVPN/openvpn3-linux/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      progrm_jarvis
    ];
    platforms = lib.platforms.linux;
  };
})
