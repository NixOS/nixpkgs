{
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  lib,
  nixosTests,
  olm,
  testers,
  mautrix-meta,
  # This option enables the use of an experimental pure-Go implementation of the
  # Olm protocol instead of libolm for end-to-end encryption. Using goolm is not
  # recommended by the mautrix developers, but they are interested in people
  # trying it out in non-production-critical environments and reporting any
  # issues they run into.
  withGoolm ? false,
}:

buildGoModule (finalAttrs: {
  pname = "mautrix-meta";
  version = "26.11";
  tag = "v0.2611.0";

  subPackages = [
    "cmd/mautrix-meta"
    "cmd/mautrix-instagram"
  ];

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "meta";
    inherit (finalAttrs) tag;
    hash = "sha256-cyA8zi+jrOC6SCRXSb2RNmqpZkpVzXShrHnCCoxPwJs=";
  };

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  vendorHash = "sha256-sootqoQ0F6TjYnWYbXws2Nu6puCTA31oEtBN8F7lkQ8=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.Tag=${finalAttrs.tag}"
  ];

  passthru = {
    tests = {
      inherit (nixosTests)
        mautrix-meta-postgres
        mautrix-meta-sqlite
        ;

      version = testers.testVersion {
        package = mautrix-meta;
        version = "v${finalAttrs.version}";
      };
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
      logn
    ];
    mainProgram = "mautrix-meta";
  };
})
