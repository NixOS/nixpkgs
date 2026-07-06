{
  fetchFromForgejo,
  installShellFiles,
  lib,
  libnotify,
  pandoc,
  patchelf,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hinoirisetr";
  version = "1.6.3";

  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "git.vavakado.xyz";
    owner = "me";
    repo = "hinoirisetr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XgIeeVCnlntf2RopA6SMuFCgbqTlTEZv6V5ezjEHVKA=";
  };

  cargoHash = "sha256-lydS9TWb+Y1PPC7C3Mn6KNVX1fsooAcDKJeKMnXWZY0=";

  nativeBuildInputs = [
    installShellFiles
    pandoc
    patchelf
  ];

  buildInputs = [
    libnotify
  ];

  postFixup = ''
    patchelf --add-rpath "${lib.getLib libnotify}/lib" $out/bin/hinoirisetr
  '';

  postBuild = ''
    pandoc manpages/hinoirisetr.1.md -s -t man -o hinoirisetr.1
  '';

  postInstall = ''
    installManPage hinoirisetr.1
  '';

  meta = {
    description = "a lightweight daemon that automatically adjusts your screen's color temperature and gamma";
    homepage = "https://git.vavakado.xyz/me/hinoirisetr";
    changelog = "https://git.vavakado.xyz/me/hinoirisetr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      vavakado
    ];
    mainProgram = "hinoirisetr";
    platforms = lib.platforms.linux;
  };
})
