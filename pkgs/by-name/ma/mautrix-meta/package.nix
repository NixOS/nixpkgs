{
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  lib,
  nixosTests,
}:

buildGoModule rec {
  pname = "mautrix-meta";
  version = "25.10";
  tag = "v0.2510.0";

  subPackages = [ "cmd/mautrix-meta" ];

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "meta";
    tag = tag;
    hash = "sha256-DcpOdJ0k3tuAuCIoN6RqXanvu2Xz6fKYhH2pkbAilvk=";
  };

  tags = "goolm";

  vendorHash = "sha256-NwnNFruc5Z162PkbShcgJkrQfcxHIF6UrP8vLbJkicI=";

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
