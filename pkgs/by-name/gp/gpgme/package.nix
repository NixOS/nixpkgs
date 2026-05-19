{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  libgpg-error,
  gnupg,
  pkg-config,
  glib,
  pth,
  libassuan,
  which,
  texinfo,
  buildPackages,
  # only for passthru.tests
  gpa,
  libsForQt5,
  qt6Packages,
  python3,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpgme";
  version = "2.0.1";

  outputs = [
    "out"
    "dev"
    "info"
  ];

  outputBin = "dev"; # gpgme-config; not so sure about gpgme-tool

  src = fetchurl {
    url = "mirror://gnupg/gpgme/gpgme-${finalAttrs.version}.tar.bz2";
    hash = "sha256-ghqwaVyELqtRdSqBmAySsEEMfq3QQQP3kdXSpSZ4SWY=";
  };

  postPatch = ''
    # remove -unknown suffix from pkgconfig version
    substituteInPlace autogen.sh \
      --replace-fail 'tmp="-unknown"' 'tmp=""'
  '';

  patches = [
    # Don't use deprecated LFS64 APIs (removed in musl 1.2.4)
    # https://dev.gnupg.org/D600
    ./LFS64.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    gnupg
    pkg-config
    texinfo
  ];

  propagatedBuildInputs = [
    glib
    libassuan
    libgpg-error
    pth
  ];

  nativeCheckInputs = [ which ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  dontWrapQtApps = true;

  configureFlags = [
    "--enable-fixed-path=${gnupg}/bin"
    "--with-libgpg-error-prefix=${libgpg-error.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
  ]
  # Tests will try to communicate with gpg-agent instance via a UNIX socket
  # which has a path length limit. Nix on darwin is using a build directory
  # that already has quite a long path and the resulting socket path doesn't
  # fit in the limit. https://github.com/NixOS/nix/pull/1085
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "--disable-gpg-test" ];

  env.NIX_CFLAGS_COMPILE = toString (
    # https://www.gnupg.org/documentation/manuals/gpgme/Largefile-Support-_0028LFS_0029.html
    lib.optional stdenv.hostPlatform.is32bit "-D_FILE_OFFSET_BITS=64"
  );

  enableParallelBuilding = true;

  # prevent tests from being run during the buildPhase
  makeFlags = [ "tests=" ];

  doCheck = true;

  checkFlags = [
    "-C"
    "tests"
  ];

  passthru.tests = {
    inherit gpa;
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    python = python3.pkgs.gpgme;
    qt5 = libsForQt5.qgpgme;
    qt6 = qt6Packages.qgpgme;
  };

  meta = {
    homepage = "https://gnupg.org/software/gpgme/index.html";
    changelog = "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gpgme.git;f=NEWS;hb=gpgme-${finalAttrs.version}";
    description = "Library for making GnuPG easier to use";
    longDescription = ''
      GnuPG Made Easy (GPGME) is a library designed to make access to GnuPG
      easier for applications. It provides a High-Level Crypto API for
      encryption, decryption, signing, signature verification and key
      management.
    '';
    license = with lib.licenses; [
      lgpl21Plus
      gpl3Plus
    ];
    pkgConfigModules = [
      "gpgme"
      "gpgme-glib"
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
