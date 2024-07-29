{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  npmHooks,
  nix-update-script,
}:
stdenvNoCC.mkDerivation rec {
  pname = "coc-diagnostic";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "iamcco";
    repo = "coc-diagnostic";
    # Upstream has no tagged versions
    rev = "f4b8774bccf1c031da51f8ee52b05bc6b2337bf9";
    hash = "sha256-+RPNFZ3OmdI9v0mY1VNJPMHs740IXvVJy4WYMgqqQSM=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-/WBOZKIIE2ERKuGwG+unXyam2JavPOuUeSIwZQ9RiHY=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    npmHooks.npmInstallHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "diagnostic-languageserver extension for coc.nvim";
    homepage = "https://github.com/iamcco/coc-diagnostic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
