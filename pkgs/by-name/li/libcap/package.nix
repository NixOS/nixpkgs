{
  stdenv,
  lib,
  buildPackages,
  fetchurl,
  fetchpatch,
  runtimeShell,
  pkgsBuildHost,
  usePam ? !isStatic,
  pam ? null,
  isStatic ? stdenv.hostPlatform.isStatic,
  go,
  withGo ? lib.meta.availableOn stdenv.buildPlatform go && stdenv.hostPlatform.go.GOARCH != null,

  # passthru.tests
  bind,
  chrony,
  htop,
  libgcrypt,
  libvirt,
  ntp,
  qemu,
  squid,
  tor,
  uwsgi,
}:

assert usePam -> pam != null;

stdenv.mkDerivation rec {
  pname = "libcap";
  version = "2.77";

  src = fetchurl {
    url = "mirror://kernel/linux/libs/security/linux-privs/libcap2/${pname}-${version}.tar.xz";
    hash = "sha256-iXvBi0Svwmxw54zq09uzHhVKzCS+4IWloJB5qI2/b1I=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
    "doc"
  ]
  ++ lib.optional usePam "pam";

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = lib.optionals withGo [
    go
  ];

  buildInputs = lib.optional usePam pam;

  makeFlags = [
    "lib=lib"
    "PAM_CAP=${lib.boolToYesNo usePam}"
    "BUILD_CC=$(CC_FOR_BUILD)"
    "CC:=$(CC)"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ]
  ++ lib.optionals withGo [
    "GOLANG=yes"
    ''GOCACHE=''${TMPDIR}/go-cache''
    "GOFLAGS=-trimpath"
    "GOARCH=${pkgsBuildHost.go.GOARCH}"
    "GOOS=${pkgsBuildHost.go.GOOS}"
  ]
  ++ lib.optionals isStatic [
    "SHARED=no"
    "LIBCSTATIC=yes"
  ];

  patches = [
    (fetchpatch {
      url = "https://git.kernel.org/pub/scm/libs/libcap/libcap.git/patch/?id=d628b3bfe40338d4efff6b0ae50f250a0eb884c7";
      hash = "sha256-Eiv/BOJZkduL+hOEJd8K1LQd9wvOeCKchE2GaLcerVc=";
    })
  ];

  postPatch = ''
    patchShebangs ./progs/mkcapshdoc.sh

    # use full path to bash
    substituteInPlace progs/capsh.c --replace "/bin/bash" "${runtimeShell}"

    # set prefixes
    substituteInPlace Make.Rules \
      --replace 'prefix=/usr' "prefix=$lib" \
      --replace 'exec_prefix=' "exec_prefix=$out" \
      --replace 'lib_prefix=$(exec_prefix)' "lib_prefix=$lib" \
      --replace 'inc_prefix=$(prefix)' "inc_prefix=$dev" \
      --replace 'man_prefix=$(prefix)' "man_prefix=$doc"
  '';

  installFlags = [ "RAISE_SETFCAP=no" ];

  postInstall = ''
    ${lib.optionalString (!isStatic) ''rm "$lib"/lib/*.a''}
    mkdir -p "$doc/share/doc/${pname}-${version}"
    cp License "$doc/share/doc/${pname}-${version}/"
  ''
  + lib.optionalString usePam ''
    mkdir -p "$pam/lib/security"
    mv "$lib"/lib/security "$pam/lib"
  '';

  strictDeps = true;

  disallowedReferences = lib.optionals withGo [
    pkgsBuildHost.go
  ];

  passthru.tests = {
    inherit
      bind
      chrony
      htop
      libgcrypt
      libvirt
      ntp
      qemu
      squid
      tor
      uwsgi
      ;
  };

  meta = {
    description = "Library for working with POSIX capabilities";
    homepage = "https://sites.google.com/site/fullycapable";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
  };
}
