{
  lib,
  stdenv,
  fetchFromGitHub,
  fftwFloat,
  chafa,
  curl,
  glib,
  libopus,
  opusfile,
  libvorbis,
  taglib,
  faad2,
  libogg,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kew";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "ravachol";
    repo = "kew";
    tag = "v${finalAttrs.version}";
    hash = "sha256-64xdxRx4OanAcLgir9N7p/q71+gQYhffnWnxZzz93h8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    fftwFloat.dev
    chafa
    curl.dev
    glib.dev
    libopus
    opusfile
    libvorbis
    taglib
    faad2
    libogg
  ];

  installFlags = [
    "MAN_DIR=${placeholder "out"}/share/man"
    "PREFIX=${placeholder "out"}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Command-line music player for Linux";
    homepage = "https://github.com/ravachol/kew";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      demine
      matteopacini
    ];
    mainProgram = "kew";
  };
})
