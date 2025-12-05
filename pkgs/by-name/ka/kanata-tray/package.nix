{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  libayatana-appindicator,
  gtk3,
  stdenv,
  pkg-config,
}:
buildGoModule (finalAttrs: {
  pname = "kanata-tray";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "rszyma";
    repo = "kanata-tray";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-IR8mWt8pLBZ24+6xY8OBFRYAYLwcRKfbGTAE0bOcLuk=";
  };

  vendorHash = "sha256-tW8NszrttoohW4jExWxI1sNxRqR8PaDztplIYiDoOP8=";

  flags = [ "-trimpath" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.buildVersion=${finalAttrs.version}"
    "-X main.buildHash=${finalAttrs.src.rev}"
  ];
  nativeBuildInputs = lib.optional stdenv.isLinux pkg-config;

  buildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.isLinux [
    libayatana-appindicator
    gtk3
  ];

  postInstall = ''
    wrapProgram $out/bin/kanata-tray \
    --run 'export KANATA_TRAY_LOG_DIR=''${KANATA_TRAY_LOG_DIR-$HOME/.cache}' \
    --prefix PATH : $out/bin
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Tray Icon for Kanata";
    homepage = "https://github.com/rszyma/kanata-tray";
    changelog = "https://github.com/rszyma/kanata-tray/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ auscyber ];
    platforms = platforms.unix;
  };
})
