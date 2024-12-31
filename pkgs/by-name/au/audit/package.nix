{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  bash,
  buildPackages,
  linuxHeaders,
  python3,
  swig,
  pkgsCross,

  # Enabling python support while cross compiling would be possible, but the
  # configure script tries executing python to gather info instead of relying on
  # python3-config exclusively
  enablePython ? stdenv.hostPlatform == stdenv.buildPlatform,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "audit";
  version = "4.0.2";

  src = fetchurl {
    url = "https://people.redhat.com/sgrubb/audit/audit-${finalAttrs.version}.tar.gz";
    hash = "sha256-1dG11Q7kotDReHW8aua9an1bNNlVfqhHo5+uxTH6qgo=";
  };

  patches = [
    (fetchpatch {
      name = "static.patch";
      url = "https://github.com/linux-audit/audit-userspace/commit/a89664b45c30a853a6f80b19730984bd78432142.patch";
      hash = "sha256-HsaL9Bfo1MQ1JBKIS9ckNTapGk5eshjWWKh4M+e+Y9c=";
    })
  ];

  postPatch = ''
    substituteInPlace bindings/swig/src/auditswig.i \
      --replace-fail "/usr/include/linux/audit.h" \
                     "${linuxHeaders}/include/linux/audit.h"
  '';

  outputs = [
    "bin"
    "lib"
    "dev"
    "out"
    "man"
  ];

  strictDeps = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs =
    [
      autoreconfHook
    ]
    ++ lib.optionals enablePython [
      python3
      swig
    ];

  buildInputs = [
    bash
  ];

  configureFlags = [
    # z/OS plugin is not useful on Linux, and pulls in an extra openldap
    # dependency otherwise
    "--disable-zos-remote"
    "--with-arm"
    "--with-aarch64"
    (if enablePython then "--with-python" else "--without-python")
  ];

  enableParallelBuilding = true;

  passthru.tests = {
    musl = pkgsCross.musl64.audit;
  };

  meta = {
    homepage = "https://people.redhat.com/sgrubb/audit/";
    description = "Audit Library";
    changelog = "https://github.com/linux-audit/audit-userspace/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
