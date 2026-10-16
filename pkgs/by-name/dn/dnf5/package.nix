{
  lib,
  stdenv,
  fetchFromGitHub,
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
  systemdLibs,
  versionCheckHook,
  toml11,
  zchunk,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dnf5";
  version = "5.4.6.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "dnf5";
    tag = finalAttrs.version;
    hash = "sha256-7TWCPX7WmGWcDZ3wNaVnwIB5IDyeSzyjuPNAN3ecpdM=";
  };

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
    systemdLibs
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
    # autoapi needs the swig-generated python bindings (WITH_PYTHON3),
    # it is only used for the python API docs, not for the man pages.
    substituteInPlace doc/conf.py.in \
      --replace-fail "'autoapi.extension'," ""
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
