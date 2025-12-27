{
  lib,
  stdenv,
  nix-update-script,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  bison,
  flex,
  libiconv,
  libpng,
  libjpeg,
  libwebp,
  zlib,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "alice-tools";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "nunuhara";
    repo = "alice-tools";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-DazWnBeI5XShkIx41GFZLP3BbE0O8T9uflvKIZUXCHo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    bison
    flex
  ];

  buildInputs = [
    libiconv
    libpng
    libjpeg
    libwebp
    zlib
  ];

  # Default install step only installs a static library of a build dependency
  installPhase = ''
    runHook preInstall

    install -Dm755 src/alice $out/bin/alice

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools for extracting/editing files from AliceSoft games";
    homepage = "https://github.com/nunuhara/alice-tools";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    changelog = "https://github.com/nunuhara/alice-tools/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "alice";
  };
})
