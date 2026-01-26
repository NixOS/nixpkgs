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
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "kmscon";
    repo = "libtsm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8db/amwcV1a5Ho0dymQxKtOFsTN6nLUnwSobuAowSwk=";
  };

  buildInputs = [ libxkbcommon ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    check
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Terminal-emulator State Machine";
    homepage = "https://www.freedesktop.org/wiki/Software/kmscon/libtsm/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    platforms = lib.platforms.linux;
  };
})
