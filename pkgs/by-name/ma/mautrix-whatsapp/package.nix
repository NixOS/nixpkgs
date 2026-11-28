{
  lib,
  nix-update-script,
  nixosTests,
  buildGoModule,
  fetchFromGitHub,
  testers,
  mautrix-whatsapp,
  olm,
  # This option enables the use of an experimental pure-Go implementation of
  # the Olm protocol instead of libolm for end-to-end encryption. Using goolm
  # is not recommended by the mautrix developers, but they are interested in
  # people trying it out in non-production-critical environments and reporting
  # any issues they run into.
  withGoolm ? false,
}:

buildGoModule (finalAttrs: {
  pname = "mautrix-whatsapp";
  version = "26.11";
  tag = "v0.2611.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    inherit (finalAttrs) tag;
    hash = "sha256-mu2ZnyPHf5ej+lsDnxfa+kYGoBWmV1Oju0E1yLerkI8=";
  };

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  vendorHash = "sha256-QRtDB7doOsmPDXX7jbzjX5Ah3ZO9Hh+r6QT8G2NI67s=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.Tag=${finalAttrs.tag}"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = mautrix-whatsapp;
        version = "v${finalAttrs.version}";
      };
      mautrix-whatsapp = nixosTests.mautrix-whatsapp;
    };
  };

  meta = {
    homepage = "https://github.com/mautrix/whatsapp";
    description = "Matrix-WhatsApp puppeting bridge";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      vskilet
      ma27
      chvp
      SchweGELBin
      logn
    ];
    mainProgram = "mautrix-whatsapp";
  };
})
