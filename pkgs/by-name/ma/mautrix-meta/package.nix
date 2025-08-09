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
  version = "0.5.2";

  subPackages = [ "cmd/mautrix-meta" ];

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "meta";
    rev = "v${version}";
    hash = "sha256-S/HWCN9d3Nhbl73RoFD684OG3CbdNWXU8QReJoSYJK0=";
  };

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  vendorHash = "sha256-m0s99gl49NzGEpuDPB5tL92krt2Zho36NsIEXJk+nCw=";

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
    description = "Matrix <-> Facebook and Matrix <-> Instagram hybrid puppeting/relaybot bridge";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      eyjhb
      sumnerevans
    ];
    mainProgram = "mautrix-meta";
  };
}
