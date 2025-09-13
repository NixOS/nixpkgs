{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  docbook_xml_dtd_45,
  docbook_xsl,
  installShellFiles,
  libxslt,
  pkg-config,
  python3,
  which,

  # buildInputs
  pcre,

  versionCheckHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppcheck";
  version = "2.18.3";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "danmar";
    repo = "cppcheck";
    tag = finalAttrs.version;
    hash = "sha256-c32dNM1tNN+Nqv5GmKHnAhWx8r9RTcv3FQ/+ROGurkw=";
  };

  nativeBuildInputs = [
    docbook_xml_dtd_45
    docbook_xsl
    installShellFiles
    libxslt
    pkg-config
    python3
    which
  ];

  buildInputs = [
    pcre
    (python3.withPackages (ps: [ ps.pygments ]))
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "MATCHCOMPILER=yes"
    "FILESDIR=$(out)/share/cppcheck"
    "HAVE_RULES=yes"
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  # test/testcondition.cpp:4949(TestCondition::alwaysTrueContainer): Assertion failed.
  doCheck = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
  doInstallCheck = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'PCRE_CONFIG = $(shell which pcre-config)' 'PCRE_CONFIG = $(PKG_CONFIG) libpcre'
  ''
  # Expected:
  # Internal Error. MathLib::toDoubleNumber: conversion failed: 1invalid
  #
  # Actual:
  # Internal Error. MathLib::toDoubleNumber: input was not completely consumed: 1invalid
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace test/testmathlib.cpp \
      --replace-fail \
        'ASSERT_THROW_INTERNAL_EQUALS(MathLib::toDoubleNumber("1invalid"), INTERNAL, "Internal Error. MathLib::toDoubleNumber: conversion failed: 1invalid");' \
        "" \
      --replace-fail \
        'ASSERT_THROW_INTERNAL_EQUALS(MathLib::toDoubleNumber("1.1invalid"), INTERNAL, "Internal Error. MathLib::toDoubleNumber: conversion failed: 1.1invalid");' \
        ""
  '';

  postBuild = ''
    make DB2MAN=${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl man
  '';

  postInstall = ''
    installManPage cppcheck.1
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  installCheckPhase = ''
    runHook preInstallCheck

    echo 'int main() {}' > ./installcheck.cpp
    $out/bin/cppcheck ./installcheck.cpp > /dev/null

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Static analysis tool for C/C++ code";
    longDescription = ''
      Check C/C++ code for memory leaks, mismatching allocation-deallocation,
      buffer overruns and more.
    '';
    homepage = "http://cppcheck.sourceforge.net";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ joachifm ];
    platforms = lib.platforms.unix;
  };
})
