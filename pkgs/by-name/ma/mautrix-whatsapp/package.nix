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
  version = "26.02";
  tag = "v0.2602.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    inherit tag;
    hash = "sha256-FcjLOZdXXj6B7Yk6shLQyd9X+UAUdnThNk0qHN3TgGE=";
  };

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  vendorHash = "sha256-kzEitFzdmeS6kKaDSMpS6pliApwa3tUObd66X+cYkek=";

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
