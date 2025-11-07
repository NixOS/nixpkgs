{
  autoconf,
  automake,
  bashNonInteractive,
  coreutils,
  fetchFromGitHub,
  fuse,
  gawk,
  gnugrep,
  gnused,
  lib,
  libusb1,
  makeBinaryWrapper,
  pciutils,
  pkg-config,
  procps,
  pv,
  stdenv,
  which,
  util-linux,
  withBfbInstall ? true,
}:

stdenv.mkDerivation rec {
  pname = "rshim-user-space";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "Mellanox";
    repo = "rshim-user-space";
    rev = "rshim-${version}";
    hash = "sha256-w2+1tUDWYmgDC0ycWGdtVfdbkZCmtvwXm47qK5PCCfg=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ]
  ++ lib.optionals withBfbInstall [ makeBinaryWrapper ];

  buildInputs = [
    pciutils
    libusb1
    fuse
  ];

  prePatch = ''
    patchShebangs scripts/bfb-install
  '';

  strictDeps = true;

  preConfigure = "./bootstrap.sh";

  installPhase = ''
    mkdir -p "$out"/bin
    cp -a src/rshim "$out"/bin/
  ''
  + lib.optionalString withBfbInstall ''
    cp -a scripts/bfb-install "$out"/bin/
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
          procps
          pv
          util-linux
          which
        ]
      }
  '';

  meta = with lib; {
    description = "User-space rshim driver for the BlueField SoC";
    longDescription = ''
      The rshim driver provides a way to access the rshim resources on the
      BlueField target from external host machine. The current version
      implements device files for boot image push and virtual console access.
      It also creates virtual network interface to connect to the BlueField
      target and provides a way to access the internal rshim registers.
    '';
    homepage = "https://github.com/Mellanox/rshim-user-space";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      thillux
    ];
  };
}
