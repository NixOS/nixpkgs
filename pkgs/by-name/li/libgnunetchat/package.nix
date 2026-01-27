{
  lib,
  stdenv,
  fetchgit,
  fetchpatch,
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
  pname = "libgnunetchat";
  version = "0.6.1";

  src = fetchgit {
    url = "https://git.gnunet.org/libgnunetchat.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FKFoIuGGPcYVRBrsqn1rnodRVCLAjLKlgZOs9v4H+8w=";
  };

  patches = [
    (fetchpatch {
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/libgnunetchat/libgnunetchat-0.6.1-gnunet-0.26.2.patch?rev=6";
      hash = "sha256-Q0FvZUXSnYwK+LsN9MoW7v+gPYmD7w4E+bXNDluhxfI=";
    })
  ];

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
