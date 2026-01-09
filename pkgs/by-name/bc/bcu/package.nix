{
  cmake,
  fetchFromGitHub,
  lib,
  libftdi1,
  libusb1,
  libyaml,
  ncurses,
  nix-update-script,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcu";
  version = "1.1.119";

  src = fetchFromGitHub {
    owner = "nxp-imx";
    repo = "bcu";
    tag = "bcu_${finalAttrs.version}";
    hash = "sha256-GVnUkIoqHED/9c3Tr4M29DB+t6Q8OPDcxVWKNn/lU/8=";
  };

  patches = [ ./darwin-install.patch ];

  postPatch = ''
    substituteInPlace create_version_h.sh \
      --replace-fail "version=\`git describe --tags --long\`" "version=${finalAttrs.src.tag}"
  '';

  enableParallelBuilding = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libftdi1
    libusb1
    libyaml
    ncurses
  ];

  passthru.updateScript = nix-update-script { };

  env.NIX_CFLAGS_COMPILE = "-Wno-pointer-sign -Wno-deprecated-declarations -Wno-switch";

  preFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -sf $out/bin/bcu_mac $out/bin/bcu
  '';

  meta = {
    description = "NXP i.MX remote control and power measurement tools";
    homepage = "https://github.com/nxp-imx/bcu";
    license = lib.licenses.bsd3;
    mainProgram = "bcu";
    maintainers = [ lib.maintainers.jmbaur ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
