{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchYarnDeps,
  yarnConfigHook,
  yarnInstallHook,
  nodejs,
}:

stdenv.mkDerivation rec {
  pname = "gancio-plugin-telegram-bridge";
  version = "1.0.4";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "bcn.convocala";
    repo = "gancio-plugin-telegram-bridge";
    rev = "v${version}";
    hash = "sha256-Da8PxCX1Z1dKJu9AiwdRDfb1r1P2KiZe8BClYB9Rz48=";
  };

  # upstream doesn't provide a yarn.lock file
  postPatch = ''
    cp --no-preserve=all ${./yarn.lock} ./yarn.lock
  '';

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = "sha256-BcRVmVA5pnFzpg2gN/nKLzENnoEdwrE0EgulDizq8Ok=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnInstallHook
    nodejs
  ];

  postInstall = ''
    ln -s "$out/lib/node_modules/gancio-plugin-telegram/index.js" "$out/index.js"
    ln -s "$out/lib/node_modules/gancio-plugin-telegram/node_modules" "$out/node_modules"
  '';

  passthru = {
    inherit nodejs;
  };

  meta = {
    description = "Telegram bridge for Gancio, republishes content to Telegram channels or groups";
    homepage = "https://framagit.org/bcn.convocala/gancio-plugin-telegram-bridge";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jbgi ];
  };
}
