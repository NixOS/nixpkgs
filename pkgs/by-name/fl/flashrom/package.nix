{
  fetchurl,
  stdenv,
  bash-completion,
  cmocka,
  lib,
  libftdi1,
  libjaylink,
  libusb1,
  openssl,
  meson,
  ninja,
  pciutils,
  pkg-config,
  sphinx,
  jlinkSupport ? false,
  git,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flashrom";
  version = "1.7.0";

  src = fetchurl {
    url = "https://download.flashrom.org/releases/flashrom-v${finalAttrs.version}.tar.xz";
    hash = "sha256-Qyis6YM/fv58M0vdc0gs3oKGgZgmzAAUnoP7qWvzq08=";
  };

  nativeBuildInputs = [
    git
    meson
    ninja
    pkg-config
    sphinx
    bash-completion
  ];
  buildInputs = [
    openssl
    cmocka
    libftdi1
    libusb1
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pciutils ]
  ++ lib.optional jlinkSupport libjaylink;

  postPatch = ''
    substituteInPlace util/flashrom_udev.rules \
      --replace 'GROUP="plugdev"' 'TAG+="uaccess", TAG+="udev-acl"'
  '';

  mesonFlags = [
    (lib.mesonBool "werror" false)
    (lib.mesonOption "programmer" "auto")
    (lib.mesonEnable "man-pages" true)
    (lib.mesonEnable "tests" (!stdenv.buildPlatform.isDarwin))
    (lib.mesonEnable "generate_authors_list" false)
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;
  doInstallCheck = true;

  postInstall = ''
    install -Dm644 $NIX_BUILD_TOP/$sourceRoot/util/flashrom_udev.rules $out/lib/udev/rules.d/flashrom.rules
  '';

  env = lib.optionalAttrs (stdenv.cc.isClang && !stdenv.hostPlatform.isDarwin) {
    NIX_CFLAGS_COMPILE = "-Wno-gnu-folding-constant";
  };

  meta = {
    homepage = "https://www.flashrom.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.all;
    mainProgram = "flashrom";
  };
})
