{ buildGoModule
, config
, fetchFromGitHub
, lib
, nixosTests
, olm
}:

buildGoModule rec {
  pname = "mautrix-meta";
  version = "0.3.1";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "meta";
    rev = "v${version}";
    hash = "sha256-zU8c/ZAKTKd4dbG056gOCiPzvPNS5/KEkJ2fw48oV00=";
  };

  buildInputs = [ olm ];

  vendorHash = "sha256-uwprj4G7HI87ZGr+6Bqkp77nzW6kgV3S5j4NGjbtOwQ=";

  passthru = {
    tests = {
      inherit (nixosTests)
        mautrix-meta-postgres
        mautrix-meta-sqlite
        ;
    };
  };

  meta = {
    homepage = "https://github.com/mautrix/meta";
    description = "Matrix <-> Facebook and Mautrix <-> Instagram hybrid puppeting/relaybot bridge";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ rutherther ];
    mainProgram = "mautrix-meta";
  };
}
