{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  pkg-config,
  libsolv,
  openssl,
  check,
  json_c,
  libmodulemd,
  util-linux,
  sqlite,
  librepo,
  libyaml,
  rpm,
  zchunk,
  cppunit,
  python3,
  swig,
  pcre2,
  sphinx,
}:

stdenv.mkDerivation rec {
  pname = "libdnf";
  version = "0.74.0";

  outputs = [
    "out"
    "dev"
    "py"
  ];

  src = fetchFromGitHub {
    owner = "rpm-software-management";
    repo = "libdnf";
    tag = version;
    hash = "sha256-NAnE8VPz2j7h/gB1A4FDwG/x7ki7QEmBjcfvOb6/+VY=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
  ];

  buildInputs = [
    check
    cppunit
    openssl
    json_c
    util-linux
    libyaml
    libmodulemd
    zchunk
    python3
    swig
    sphinx
    pcre2.dev
  ];

  propagatedBuildInputs = [
    sqlite
    libsolv
    librepo
    rpm
  ];

  # See https://github.com/NixOS/nixpkgs/issues/107430
  prePatch = ''
    cp ${libsolv}/share/cmake/Modules/FindLibSolv.cmake cmake/modules/
  '';

  patches = [ ./fix-python-install-dir.patch ];

  postPatch = ''
    # https://github.com/rpm-software-management/libdnf/issues/1518
    substituteInPlace libdnf/libdnf.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
    substituteInPlace cmake/modules/FindPythonInstDir.cmake \
      --replace "@PYTHON_INSTALL_DIR@" "$out/${python3.sitePackages}"
  '';

  cmakeFlags = [
    "-DWITH_GTKDOC=OFF"
    "-DWITH_HTML=OFF"
    "-DPYTHON_DESIRED=${lib.head (lib.splitString [ "." ] python3.version)}"
  ];

  postInstall = ''
    rm -r $out/${python3.sitePackages}/hawkey/test
  '';

  postFixup = ''
    moveToOutput "lib/${python3.libPrefix}" "$py"
  '';

  meta = {
    description = "Package management library";
    homepage = "https://github.com/rpm-software-management/libdnf";
    changelog = "https://github.com/rpm-software-management/libdnf/releases/tag/${version}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      rb2k
      katexochen
    ];
  };
}
