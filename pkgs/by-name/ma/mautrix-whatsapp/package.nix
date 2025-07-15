{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
  olm,
  # This option enables the use of an experimental pure-Go implementation of
  # the Olm protocol instead of libolm for end-to-end encryption. Using goolm
  # is not recommended by the mautrix developers, but they are interested in
  # people trying it out in non-production-critical environments and reporting
  # any issues they run into.
  withGoolm ? false,
}:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-Es6RWUo/e25wYGIz6feVNXIQbMCDPl1iZoKT3x8vHtA=";
  };

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  vendorHash = "sha256-/R6MI6egGV1E1YzKcxBSOb2z97kA1HCK5GdMgfR1vSM=";

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
