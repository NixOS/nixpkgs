{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libsecret,
  libfido2,
}:

buildGoModule (finalAttrs: {
  pname = "protonmail-bridge";
  version = "3.23.1";

  src = fetchFromGitHub {
    owner = "ProtonMail";
    repo = "proton-bridge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QSK+MiHE8JFtUM4r+4xswOcNrcUd0flxuSf5uG2kZnI=";
  };

  vendorHash = "sha256-Ww42BbdMHVUUc074vWNYTEMr1myqDPLgkMsaTarziag=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libsecret
    libfido2
  ];

  preBuild = ''
    patchShebangs ./utils/
    (cd ./utils/ && ./credits.sh bridge)
  '';

  ldflags =
    let
      constants = "github.com/ProtonMail/proton-bridge/v3/internal/constants";
    in
    [
      "-X ${constants}.Version=${finalAttrs.version}"
      "-X ${constants}.Revision=${finalAttrs.src.rev}"
      "-X ${constants}.buildTime=unknown"
      "-X ${constants}.FullAppName=ProtonMailBridge" # Should be "Proton Mail Bridge", but quoting doesn't seems to work in nix's ldflags
    ];

  subPackages = [
    "cmd/Desktop-Bridge"
  ];

  postInstall = ''
    mv $out/bin/Desktop-Bridge $out/bin/protonmail-bridge # The cli is named like that in other distro packages
  '';

  meta = {
    changelog = "https://github.com/ProtonMail/proton-bridge/blob/${finalAttrs.src.rev}/Changelog.md";
    description = "Use your ProtonMail account with your local e-mail client";
    downloadPage = "https://github.com/ProtonMail/proton-bridge/releases";
    homepage = "https://github.com/ProtonMail/proton-bridge";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      An application that runs on your computer in the background and seamlessly encrypts
      and decrypts your mail as it enters and leaves your computer.

      To work, use secret-service freedesktop.org API (e.g. Gnome keyring) or pass.
    '';
    mainProgram = "protonmail-bridge";
    maintainers = with lib.maintainers; [
      mrfreezeex
      daniel-fahey
    ];
  };
})
