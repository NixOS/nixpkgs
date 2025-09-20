{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.12.5";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-FywU4nT/EjEqiC+67FWi3Ni63NI8nqJka6bPdfq1c30=";
  };

  tags = "goolm";

  vendorHash = "sha256-LjlI5zqM1GS+7Sx1mqiwZHM4mPifX7MyLbqEckb90Jo=";

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      vskilet
      ma27
      chvp
      SchweGELBin
    ];
    mainProgram = "mautrix-whatsapp";
  };
}
