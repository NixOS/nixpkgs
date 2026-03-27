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
  version = "5.2.18.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "dnf5";
    tag = finalAttrs.version;
    hash = "sha256-VTuGHHNNdoDfbJ86GOR4a+Fy2s+NSXPH337+AZpLKuo=";
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
    "-DWITH_PERL5=OFF"
    "-DWITH_PYTHON3=OFF"
    "-DWITH_RUBY=OFF"
    "-DWITH_SYSTEMD=OFF"
    "-DWITH_PLUGIN_RHSM=OFF" # Red Hat Subscription Manager plugin
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
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
