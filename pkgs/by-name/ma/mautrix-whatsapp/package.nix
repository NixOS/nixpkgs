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
  version = "26.01";
  tag = "v0.2601.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    inherit tag;
    hash = "sha256-CNrAQSZgF0t5oo2xRsVdif3LIGOnTe2ea996icVkCjE=";
  };

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  vendorHash = "sha256-Jvd3NgDRCyLrRV+6+kmcUSPCSSaxaKLD9EdrSyFwm1M=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.Tag=${tag}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/mautrix/whatsapp";
    description = "Matrix-WhatsApp puppeting bridge";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      vskilet
      ma27
      chvp
      SchweGELBin
    ];
    mainProgram = "mautrix-whatsapp";
  };
}
