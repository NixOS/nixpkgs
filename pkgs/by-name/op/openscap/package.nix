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
  makeWrapper,
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
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "OpenSCAP";
    repo = "openscap";
    rev = version;
    hash = "sha256-AOldgYS8qMOLB/Nm2/O0obdDOrefSrubTETb50f3Gv8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    asciidoc
    doxygen
    makeWrapper
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

    # Patch SCE engine to not hardcode FHS paths, allowing it to use the transient environment's PATH
    substituteInPlace src/SCE/sce_engine.c \
      --replace-fail 'env_values[0] = "PATH=/bin:/sbin:/usr/bin:/usr/local/bin:/usr/sbin";' 'env_values[0] = "_PATCHED_OUT_DUMMY_VAR=patched-out";'
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

  postFixup = ''
    # Set plugin directory to discover the SCE plugin.
    # openscap calls dlopen with this as the directory prefix.
    wrapProgram $out/bin/oscap \
      --set OSCAP_CHECK_ENGINE_PLUGIN_DIR $out/lib
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
