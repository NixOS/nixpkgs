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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
    hash = "sha256-V4waFxYmWHBV5H0R3H//hB6pXhYPgRCWkkBwf3EC5bQ=";
  };

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  vendorHash = "sha256-CZg0POONweix6CXPnXDprCF7F8BN06awtNCVdJMoPnU=";

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
    ];
    mainProgram = "mautrix-whatsapp";
  };
}
