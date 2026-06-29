{
  lib,
  stdenv,
  fetchFromGitHub,
  sdl3,
  ninja,
  meson,
  pkg-config,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pipewalker";
  version = "1.1-unstable-2026-03-09";

  src = fetchFromGitHub {
    owner = "artemsen";
    repo = "pipewalker";
    rev = "8b23069f430a5ac4eabf231cba2247ddc96488b9";
    hash = "sha256-56gd2A23+byR5/RfXS0LSwqXrA0zN6iWlpYLz+H29z8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ sdl3 ];

  mesonFlags = [
    "-Dversion=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Combine components into single circuit puzzle game";
    homepage = "https://github.com/artemsen/pipewalker/";
    mainProgram = "pipewalker";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
