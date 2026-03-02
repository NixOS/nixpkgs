{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchYarnDeps,
  yarn,
  yarnConfigHook,
  yarnInstallHook,
  nodejs_22,
  nix-update-script,
}:

let
  # The latest nodejs is always used in yarn, leading to build issues when it's
  # different from the pinned one.
  nodejs = nodejs_22;
  yarnConfigHook' = yarnConfigHook.override {
    yarn = yarn.override { inherit nodejs; };
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "gancio-plugin-telegram-bridge";
  version = "1.0.6";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "bcn.convocala";
    repo = "gancio-plugin-telegram-bridge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-J7FIfJjounrq/hPQk58mYXigjD7BZQWoE4aGi0eJ4sY=";
  };

  # upstream doesn't provide a yarn.lock file
  postPatch = ''
    cp --no-preserve=all ${./yarn.lock} ./yarn.lock
  '';

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = "sha256-3842mgKcsa0FIAFdClVorYFKWODiQJm7ytw2bkJ1WG4=";
  };

  nativeBuildInputs = [
    yarnConfigHook'
    yarnInstallHook
    nodejs
  ];

  postInstall = ''
    ln -s "$out/lib/node_modules/gancio-plugin-telegram/index.js" "$out/index.js"
    ln -s "$out/lib/node_modules/gancio-plugin-telegram/node_modules" "$out/node_modules"
  '';

  passthru = {
    inherit nodejs;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Telegram bridge for Gancio, republishes content to Telegram channels or groups";
    homepage = "https://framagit.org/bcn.convocala/gancio-plugin-telegram-bridge";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jbgi ];
  };
})
