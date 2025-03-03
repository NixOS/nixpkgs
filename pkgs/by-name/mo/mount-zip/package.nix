{
  lib,
  stdenv,
  fetchFromGitHub,
  fuse,
  boost,
  icu,
  libzip,
  pandoc,
  pkg-config,
  versionCheckHook,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mount-zip";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mount-zip";
    rev = "v${finalAttrs.version}";
    hash = "sha256-akiZwuwrsj+62TmZEJamlvQ1rSyFA4hrH0TcZ8T97z4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pandoc
    pkg-config
  ];

  buildInputs = [
    boost
    fuse
    icu
    libzip
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "FUSE file system for ZIP archives";
    homepage = "https://github.com/google/mount-zip";
    changelog = "https://github.com/google/mount-zip/releases/tag/v${finalAttrs.version}";
    longDescription = ''
      mount-zip is a tool allowing to open, explore and extract ZIP archives.

      This project is a fork of fuse-zip.
    '';
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      arti5an
      progrm_jarvis
    ];
    platforms = lib.platforms.linux;
    mainProgram = "mount-zip";
  };
})
