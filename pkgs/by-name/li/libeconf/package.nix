{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  meson,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libeconf";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "libeconf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xvnyFdsv9sSXeSaKLHkk7DXZAf6XwY6KJfFSSNgnWOI=";
  };

  nativeBuildInputs = [
    cmake
    meson
    ninja
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Enhanced config file parser, which merges config files placed in several locations into one";
    homepage = "https://github.com/openSUSE/libeconf";
    changelog = "https://github.com/openSUSE/libeconf/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ grimmauld ];
    mainProgram = "libeconf";
    platforms = lib.platforms.all;
  };
})
