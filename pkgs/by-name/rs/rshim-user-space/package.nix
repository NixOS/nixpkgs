{
  autoconf,
  automake,
  bashNonInteractive,
  coreutils,
  fetchFromGitHub,
  fetchpatch2,
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
  systemd,
  util-linux,
  which,
  withBfbInstall ? true,
}:

stdenv.mkDerivation rec {
  pname = "rshim-user-space";
  version = "2.5.7";

  src = fetchFromGitHub {
    owner = "Mellanox";
    repo = "rshim-user-space";
    rev = "rshim-${version}";
    hash = "sha256-dXrReU6Wx8t6ObrrF3MeUWdFBSfn6tyQqQdGBAZsvDg=";
  };

  # came up shortly after 2.5.7 release, remove with next update
  patches = [
    (fetchpatch2 {
      name = "rshim-fix-bfb-install.patch";
      url = "https://github.com/Mellanox/rshim-user-space/commit/0b2b17eeb04d80b7efb20aa2a9dc24759680aaea.patch";
      hash = "sha256-JqnCGWM6Wjg+WFQhqHv6h4VbawyCf75L4wfd7L+n7po=";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ]
  ++ lib.optionals withBfbInstall [ makeBinaryWrapper ];

  buildInputs = [
    fuse
    libusb1
    pciutils
    systemd
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
          systemd
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
