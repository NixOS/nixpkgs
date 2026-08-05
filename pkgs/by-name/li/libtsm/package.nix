{
  lib,
  stdenv,
  fetchFromGitHub,
  libxkbcommon,
  pkg-config,
  meson,
  ninja,
  check,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtsm";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "kmscon";
    repo = "libtsm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CN5ktki8fbvmiGiyDvDf4ayRKakpWRI51SdhRbFqNVM=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [
    libxkbcommon
    check
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Terminal-emulator State Machine";
    homepage = "https://www.freedesktop.org/wiki/Software/kmscon/libtsm/";
    changelog = "https://github.com/kmscon/libtsm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    platforms = lib.platforms.linux;
  };
})
