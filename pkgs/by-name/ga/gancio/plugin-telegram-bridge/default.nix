{
  mkYarnPackage,
  nodejs,
  fetchFromGitLab,
  fetchYarnDeps,
  lib,
  ...
}:
mkYarnPackage (rec {
  inherit nodejs;
  version = "1.0.4";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "bcn.convocala";
    repo = "gancio-plugin-telegram-bridge";
    rev = "v${version}";
    sha256 = "sha256-Da8PxCX1Z1dKJu9AiwdRDfb1r1P2KiZe8BClYB9Rz48=";
  };

  offlineCache = fetchYarnDeps {
    inherit yarnLock;
    sha256 = "sha256-BcRVmVA5pnFzpg2gN/nKLzENnoEdwrE0EgulDizq8Ok=";
  };

  packageJSON = ./package.json;

  yarnLock = ./yarn.lock;

  doDist = false;

  postInstall = ''
    cd $out
    rmdir bin
    ln -s $out/libexec/gancio-plugin-telegram/deps/gancio-plugin-telegram/index.js ./
    ln -s $out/libexec/gancio-plugin-telegram/node_modules ./
  '';

  meta = with lib; {
    description = "Telegram bridge for Gancio, republishes content to Telegram channels or groups.";
    homepage = "https://framagit.org/bcn.convocala/gancio-plugin-telegram-bridge";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jbgi ];
  };
})
