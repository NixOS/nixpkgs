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
  version = "25.10";
  tag = "v0.2510.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    tag = tag;
    hash = "sha256-jJIVlK4vTJpwjugKNtWZhO31t7YX+q3W+ZmU1w/itvM=";
  };

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  vendorHash = "sha256-LvGapdyGYXNUsC0qniwdoA3pUrOivfFq+nEilw5xFNM=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.Tag=${tag}"
  ];

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
