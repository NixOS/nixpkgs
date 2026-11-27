{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mmdoc";
  version = "0.30.7";

  src = fetchFromGitHub {
    owner = "ryantm";
    repo = "mmdoc";
    tag = finalAttrs.version;
    hash = "sha256-gKqVduAEjC/OOl8btGhrpvo7fK/zJyv6F5BdZyc+E/4=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  doCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  meta = {
    description = "Minimal Markdown Documentation";
    mainProgram = "mmdoc";
    homepage = "https://github.com/ryantm/mmdoc";
    changelog = "https://github.com/ryantm/mmdoc/releases/tag/${finalAttrs.version}";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ ryantm ];
    platforms = lib.platforms.unix;
  };
})
