{
  autoconf,
  automake,
  bashNonInteractive,
  coreutils,
  fetchFromGitHub,
  fuse3,
  gawk,
  gnugrep,
  gnused,
  lib,
  libusb1,
  makeBinaryWrapper,
  pciutils,
  perl,
  pkg-config,
  procps,
  pv,
  stdenv,
  systemd,
  util-linux,
  which,
  withBfbInstall ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rshim-user-space";
  version = "2.7.3";

  src = fetchFromGitHub {
    owner = "Mellanox";
    repo = "rshim-user-space";
    rev = "rshim-${finalAttrs.version}";
    hash = "sha256-2Hu5ysjh38dBaGeZirke+qMb6jw+6sTh8qd4LPei5ms=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ]
  ++ lib.optionals withBfbInstall [ makeBinaryWrapper ];

  buildInputs = [
    fuse3
    libusb1
    pciutils
    systemd
  ];

  patches = [
    # https://github.com/Mellanox/rshim-user-space/pull/391
    # Avoid nested PKG_CHECK_MODULES which leaks help text into ./configure
    # as bare shell, producing "fuse_CFLAGS: command not found" noise.
    ./fix-fuse-3-support.patch
    # https://github.com/Mellanox/rshim-user-space/pull/363
    # Fix console handling under glibc >= 2.42 where struct termio was removed.
    ./fix-console-handling.patch
  ];

  prePatch = ''
    patchShebangs scripts/bfb-install
    patchShebangs scripts/bf-reg
    substituteInPlace scripts/bfb-install \
      --replace-fail 'bf-reg' "${placeholder "out"}/bin/bf-reg"
  '';

  strictDeps = true;

  preConfigure = "./bootstrap.sh";

  installPhase = ''
    mkdir -p "$out"/bin
    cp -a src/rshim "$out"/bin/
  ''
  + lib.optionalString withBfbInstall ''
    cp -a scripts/bfb-install "$out"/bin/
    cp -a scripts/bf-reg "$out"/bin/
  '';

  postFixup = lib.optionalString withBfbInstall ''
    wrapProgram $out/bin/bfb-install \
      --set PATH ${
        lib.makeBinPath [
          bashNonInteractive
          coreutils
          gawk
          gnugrep
          gnused
          pciutils
          perl
          procps
          pv
          systemd
          util-linux
          which
        ]
      }
  '';

  meta = {
    description = "User-space rshim driver for the BlueField SoC";
    longDescription = ''
      The rshim driver provides a way to access the rshim resources on the
      BlueField target from external host machine. The current version
      implements device files for boot image push and virtual console access.
      It also creates virtual network interface to connect to the BlueField
      target and provides a way to access the internal rshim registers.
    '';
    homepage = "https://github.com/Mellanox/rshim-user-space";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      thillux
    ];
  };
})
