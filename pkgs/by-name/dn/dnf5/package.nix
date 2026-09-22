{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  appstream,
  cmake,
  createrepo_c,
  doxygen,
  gettext,
  help2man,
  pkg-config,
  python3,
  python3Packages,
  cppunit,
  fmt,
  json_c,
  libmodulemd,
  librepo,
  util-linux,
  libsolv,
  libxml2,
  libyaml,
  libpkgmanifest,
  acl,
  pcre2,
  rpm,
  sdbus-cpp_2,
  sphinx,
  sqlite,
  systemd,
  versionCheckHook,
  toml11,
  zchunk,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dnf5";
  version = "5.4.4.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "dnf5";
    tag = finalAttrs.version;
    hash = "sha256-l0wdC2XMl8CevKtq4VINoCZ4p/KEMCKaKTQ8bjskb3M=";
  };

  patches = [
    # fmt 12.2.0 no longer includes <cstring> transitively.
    (fetchpatch {
      url = "https://github.com/rpm-software-management/dnf5/commit/10b3ea5df53349511df179eee8dbe3b7a77e8ba4.patch";
      hash = "sha256-vhkEqoFtB/hk1vhHo6qpzrqbEVrn5eVdsDsnNsb70uM=";
    })
  ];

  nativeBuildInputs = [
    cmake
    createrepo_c
    doxygen
    gettext
    help2man
    pkg-config
    sphinx
  ]
  ++ (with python3Packages; [
    breathe
    sphinx-autoapi
    sphinx-rtd-theme
  ]);

  buildInputs = [
    appstream
    cppunit
    fmt
    json_c
    libmodulemd
    librepo
    util-linux
    libsolv
    libpkgmanifest
    acl
    libxml2
    libyaml
    pcre2.dev
    rpm
    sdbus-cpp_2
    sqlite
    systemd
    toml11
    zchunk
  ];

  # workaround for https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105329
  env.NIX_CFLAGS_COMPILE = "-Wno-restrict -Wno-maybe-uninitialized";

  cmakeFlags = [
    (lib.cmakeBool "WITH_PERL5" false)
    (lib.cmakeBool "WITH_PYTHON3" false)
    (lib.cmakeBool "WITH_RUBY" false)
    (lib.cmakeBool "WITH_SYSTEMD" false)
    (lib.cmakeBool "WITH_PLUGIN_RHSM" false) # Red Hat Subscription Manager plugin
    # doc/atp.py preprocesses manpages, but upstream only runs
    # find_package(Python3) from targets gated on WITH_PYTHON3.
    (lib.cmakeFeature "Python3_EXECUTABLE" (lib.getExe python3))
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ];

  postBuild = ''
    make doc
  '';

  prePatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/usr/lib/systemd/system" "$out/lib/systemd/system"
    substituteInPlace dnf5daemon-server/dbus/CMakeLists.txt \
      --replace-fail "/usr" "$out"
    substituteInPlace dnf5daemon-server/polkit/CMakeLists.txt \
      --replace-fail "/usr" "$out"
    substituteInPlace dnf5/CMakeLists.txt \
      --replace-fail "/etc/bash_completion.d" "$out/etc/bash_completion.d"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  preVersionCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Next-generation RPM package management system";
    homepage = "https://github.com/rpm-software-management/dnf5";
    changelog = "https://github.com/rpm-software-management/dnf5/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      malt3
      katexochen
    ];
    mainProgram = "dnf5";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
