{
  lib,
  stdenv,
  fetchFromGitHub,
  libjpeg,
  libpng,
  ncurses,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  bash-completion,
  libwebp,
  libexif,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jp2a";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "Talinx";
    repo = "jp2a";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GvPRLYrqZyzk24RmJJ1VcnXo6uda50qqqRA/pioPm5Q=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  buildInputs = [
    bash-completion
    libjpeg
    libpng
    ncurses
    libwebp
    libexif
  ];

  installFlags = [ "bashcompdir=${placeholder "out"}/share/bash-completion/completions" ];

  __structuredAttrs = true;

  strictDeps = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/Talinx/jp2a";
    description = "Small utility that converts JPG images to ASCII";
    changelog = "https://github.com/Talinx/jp2a/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.FlorianFranzen ];
    platforms = lib.platforms.unix;
    mainProgram = "jp2a";
  };
})
