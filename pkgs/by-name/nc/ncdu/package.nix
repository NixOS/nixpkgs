{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  pkg-config,
  zig_0_15,
  zstd,
  installShellFiles,
  versionCheckHook,
  pie ? stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncdu";
  version = "2.9.1";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/ncdu-${finalAttrs.version}.tar.gz";
    hash = "sha256-v9EJThQA7onP1ZIA6rlA8CXM3AwjgGcQXJhKPEhXv34=";
  };

  nativeBuildInputs = [
    zig_0_15.hook
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    ncurses
    zstd
  ];

  zigBuildFlags = lib.optional pie "-Dpie=true";

  postInstall = ''
    installManPage ncdu.1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://dev.yorhel.nl/ncdu";
    description = "Disk usage analyzer with an ncurses interface";
    changelog = "https://dev.yorhel.nl/ncdu/changes2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pSub
      rodrgz
      defelo
      ryan4yin
    ];
    inherit (zig_0_15.meta) platforms;
    mainProgram = "ncdu";
  };
})
