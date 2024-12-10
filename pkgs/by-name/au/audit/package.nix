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
  version = "4.0";

  src = fetchurl {
    url = "https://people.redhat.com/sgrubb/audit/audit-${finalAttrs.version}.tar.gz";
    hash = "sha256-v0ItQSard6kqTDrDneVHPyeNw941ck0lGKSMe+FdVNg=";
  };

  patches = [
    (fetchpatch {
      name = "musl.patch";
      url = "https://github.com/linux-audit/audit-userspace/commit/64cb48e1e5137b8a389c7528e611617a98389bc7.patch";
      hash = "sha256-DN2F5w+2Llm80FZntH9dvdyT00pVBSgRu8DDFILyrlU=";
    })
    (fetchpatch {
      name = "musl.patch";
      url = "https://github.com/linux-audit/audit-userspace/commit/4192eb960388458c85d76e5e385cfeef48f02c79.patch";
      hash = "sha256-G6CJ9nBJSsTyJ0qq14PVo+YdInAvLLQtXcR25Q8V5/4=";
    })
  ];

  postPatch = ''
    substituteInPlace bindings/swig/src/auditswig.i \
      --replace "/usr/include/linux/audit.h" \
                "${linuxHeaders}/include/linux/audit.h"
  '';

  outputs = [
    "bin"
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
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
