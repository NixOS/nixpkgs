{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsepol,
  popt,
  libxml2,
  libxslt,
  openssl,
  util-linux,
  pcre2,
  libselinux,
  graphviz,
  glib,
  python3,
  swig,
  libgcrypt,
  opendbx,
  xmlbird,
  haskellPackages,
  libyaml,
  yaml-filter,
  xmlsec,
  bzip2,
  valgrind,
  asciidoc,
  installShellFiles,
  rpm,
  system-sendmail,
  gnome2,
  curl,
  procps,
  systemd,
  perl,
  doxygen,
  pkg-config,
  perl538Packages,
}:

stdenv.mkDerivation rec {
  pname = "openscap";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "OpenSCAP";
    repo = "openscap";
    rev = version;
    hash = "sha256-LYDXASy1yZA+GfUKaXUKyZgdRqGERvMeyVIHJFfCfII=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    asciidoc
    doxygen
    rpm
    swig
    util-linux
    pkg-config
  ];

  buildInputs =
    with perl538Packages;
    [
      XMLXPath
      LinuxACL
      XMLTokeParser
    ]
    ++ [
      perl
      popt
      openssl
      valgrind
      pcre2
      libxslt
      xmlsec
      libselinux
      libyaml
      xmlbird
      installShellFiles
      bzip2
      yaml-filter
      python3
      libgcrypt
      libxml2
      systemd
      haskellPackages.pthread
      graphviz
      system-sendmail
      procps
      libsepol
      curl
      glib
      gnome2.ORBit2
      opendbx
    ];

  prePatch = ''
    export SWIG_PERL_DIR=lib/perl
    substituteInPlace swig/perl/CMakeLists.txt \
      --replace-fail "DESTINATION ''${PERL_VENDORLIB}" "DESTINATION ''${SWIG_PERL_DIR}''${PERL_VERSION}" \
      --replace-fail "DESTINATION ''${PERL_VENDORARCH}" "DESTINATION ''${SWIG_PERL_DIR}"
    substituteInPlace src/common/oscap_pcre.c \
      --replace-fail "#include <pcre2.h>" "#include <${pcre2.dev}/include/pcre2.h>"
  '';

  cmakeFlags = [
    "-DPCRE2_INCLUDE_DIRS=${pcre2.dev}/include"
    "-DPCRE2_LIBRARIES=${pcre2.out}/lib"
    "-DENABLE_DOCS=TRUE"
    "-DENABLE_TESTS=TRUE"
    "-DENABLE_OSCAP_UTIL=TRUE"
    "-DENABLE_OSCAP_UTIL_CHROOT=TRUE"
    "-DENABLE_OSCAP_UTIL_SSH=TRUE"
    "-DENABLE_OSCAP_UTIL_DOCKER=TRUE"
    "-DENABLE_OSCAP_REMEDIATE_SERVICE=TRUE"
    "-DOPENSCAP_PROBE_INDEPENDENT_YAMLFILECONTENT=TRUE"
    "-DSYSTEMD_UNITDIR=lib/systemd/system"
    "-DENABLE_VALGRIND=TRUE"
    "-DENABLE_OSCAP_REMEDIATE_SERVICE=TRUE"
    "-DPYTHON_SITE_PACKAGES_INSTALL_DIR=${python3.pkgs.python.sitePackages}"
    "-DOPENSCAP_INSTALL_DESTINATION=bin"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_MANDIR=share"
    "-DENABLE_MITRE=TRUE"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_DATADIR=share"
    "-DBUILD_TESTING=ON"
    "-DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON"
    "-DCMAKE_POLICY_DEFAULT_CMP0025=NEW"
  ];

  postBuild = ''
    make $makeFlags docs
  '';

  installPhase = ''
    make install
    installManPage $out/share/man8/*.8
    rm -rf $out/share/man8
  '';

  meta = {
    description = "NIST Certified SCAP 1.2 toolkit";
    homepage = "https://github.com/OpenSCAP/openscap";
    changelog = "https://github.com/OpenSCAP/openscap/blob/${src.rev}/NEWS";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "oscap";
    platforms = lib.platforms.linux;
  };
}
