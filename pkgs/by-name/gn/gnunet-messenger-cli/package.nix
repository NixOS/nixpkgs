{
  lib,
  stdenv,
  fetchgit,
  meson,
  ninja,
  pkg-config,
  gnunet,
  libsodium,
  libgcrypt,
  libgnunetchat,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnunet-messenger-cli";
  version = "0.3.1";

  src = fetchgit {
    url = "https://git.gnunet.org/messenger-cli.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Iby3IZXEZJ1dqVV62xDzXx/qq7JKhVtn6ZLb697ZSw=";
  };

  env.INSTALL_DIR = (placeholder "out") + "/";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gnunet
    libgcrypt
    libgnunetchat
    libsodium
    ncurses
  ];

  # No update script for now as the Nix-update-script didn't work for this

  preInstall = "mkdir -p $out/bin";

  preFixup = "mv $out/bin/messenger-cli $out/bin/gnunet-messenger-cli";

  meta = {
    description = "decentralized, privacy-preserving networking framework for secure peer-to-peer communication";
    homepage = "https://git.gnunet.org/messenger-cli.git";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    teams = with lib.teams; [ ngi ];
    maintainers = [ lib.maintainers.oluchitheanalyst ];
  };
})
