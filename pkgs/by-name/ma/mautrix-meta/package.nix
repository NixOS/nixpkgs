{
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  lib,
  nixosTests,
  olm,
  # This option enables the use of an experimental pure-Go implementation of the
  # Olm protocol instead of libolm for end-to-end encryption. Using goolm is not
  # recommended by the mautrix developers, but they are interested in people
  # trying it out in non-production-critical environments and reporting any
  # issues they run into.
  withGoolm ? false,
}:

buildGoModule rec {
  pname = "mautrix-meta";
  version = "26.10";
  tag = "v0.2610.0";

  subPackages = [
    "cmd/mautrix-meta"
    "cmd/mautrix-instagram"
  ];

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "meta";
    inherit tag;
    hash = "sha256-wqNOd+Y9pJ3sTKT4HIFlBj6m3uXyA0hdyzGUe3Mnq/g=";
  };

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  vendorHash = "sha256-laFTKwhHShyItSbcLJLIgZI7t0T9oX9hWtpcbWTSB40=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.Tag=${tag}"
  ];

  passthru = {
    tests = {
      inherit (nixosTests)
        mautrix-meta-postgres
        mautrix-meta-sqlite
        ;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/mautrix/meta";
    description = "Matrix-Meta puppeting bridge";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      eyjhb
      sumnerevans
    ];
    mainProgram = "mautrix-meta";
  };
}
