{
  lib,
  stdenv,
  fetchFromGitHub,
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
  libsmartcols,
  libsolv,
  libxml2,
  libyaml,
  pcre2,
  rpm,
  sdbus-cpp,
  sphinx,
  sqlite,
  systemd,
  testers,
  toml11,
  zchunk,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dnf5";
  version = "5.2.8.1";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "dnf5";
    rev = finalAttrs.version;
    hash = "sha256-R9woS84vZkF7yatbJr7KNhaUsLZcGaiS+XnYXG3i1jA=";
  };

  nativeBuildInputs =
    [
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
    cppunit
    fmt
    json_c
    libmodulemd
    librepo
    libsmartcols
    libsolv
    libxml2
    libyaml
    pcre2.dev
    rpm
    sdbus-cpp
    sqlite
    systemd
    toml11
    zchunk
  ];

  # workaround for https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105329
  NIX_CFLAGS_COMPILE = "-Wno-restrict -Wno-maybe-uninitialized";

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

  dontFixCmake = true;

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Next-generation RPM package management system";
    homepage = "https://github.com/rpm-software-management/dnf5";
    changelog = "https://github.com/rpm-software-management/dnf5/releases/tag/${finalAttrs.version}";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      malt3
      katexochen
    ];
    mainProgram = "dnf5";
    platforms = platforms.linux ++ platforms.darwin;
  };
})
