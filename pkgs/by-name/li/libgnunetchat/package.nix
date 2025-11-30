{
  lib,
  stdenv,
  fetchgit,
  meson,
  ninja,
  pkg-config,
  validatePkgConfig,
  testers,
  check,
  gnunet,
  libsodium,
  libgcrypt,
  libextractor,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "libgnunetchat";
  version = "0.6.0";

  src = fetchgit {
    url = "https://git.gnunet.org/libgnunetchat.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pRO8i7tHynCqm97RLMBOiWKCl2CAYBE6RXfyIljIiQ0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    validatePkgConfig
  ];

  buildInputs = [
    check
    gnunet
    libextractor
    libgcrypt
    libsodium
  ];

  env.INSTALL_DIR = (placeholder "out") + "/";

  prePatch = "mkdir -p $out/lib";

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    pkgConfigModules = [ "gnunetchat" ];
    description = "Library for secure, decentralized chat using GNUnet network services";
    homepage = "https://git.gnunet.org/libgnunetchat.git";
    changelog = "https://git.gnunet.org/libgnunetchat.git/plain/ChangeLog?h=v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    teams = with lib.teams; [ ngi ];
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
})
