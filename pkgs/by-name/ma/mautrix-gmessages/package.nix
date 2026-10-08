{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  nix-update-script,
  testers,
  mautrix-gmessages,
  # This option enables the use of an experimental pure-Go implementation of the
  # Olm protocol instead of libolm for end-to-end encryption. Using goolm is not
  # recommended by the mautrix developers, but they are interested in people
  # trying it out in non-production-critical environments and reporting any
  # issues they run into.
  withGoolm ? false,
}:

buildGoModule rec {
  pname = "mautrix-gmessages";
  version = "26.08";
  tag = "v0.2608.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "gmessages";
    inherit tag;
    hash = "sha256-wqjc074zKHkgqFcnBPFmR36xE5CVzRvupF3AdlQ0Lwk=";
  };

  vendorHash = "sha256-UL7YxLF/DMwkGP8TEaN48wYGrlfBYHSZQqc7UqdhDKE=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.Tag=${tag}"
  ];

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = mautrix-gmessages; };
  };

  meta = {
    description = "Matrix-Google Messages puppeting bridge";
    homepage = "https://github.com/mautrix/gmessages";
    changelog = "https://github.com/mautrix/gmessages/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ sumnerevans ];
    mainProgram = "mautrix-gmessages";
  };
}
