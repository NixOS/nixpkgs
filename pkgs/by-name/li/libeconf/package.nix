{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libeconf";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "libeconf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZXZcXQdG3hXAMwwftrIWL5GbVdPXk+AyqdhGTnaKL1I=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Enhanced config file parser, which merges config files placed in several locations into one";
    homepage = "https://github.com/openSUSE/libeconf";
    changelog = "https://github.com/openSUSE/libeconf/blob/${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ grimmauld ];
    mainProgram = "econftool";
    platforms = lib.platforms.all;
  };
})
