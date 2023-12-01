{ lib, stdenv
, rustPlatform
, fetchCrate
, libiconv
, openssl
, pkg-config
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-health";
  version = "0.2.3";

  src = fetchCrate {
    inherit version;
    pname = "nix_health";
    hash = "sha256-WdzzEFk9VPld6AFTNRsaQbMymw1+mNn/TViGO/Qv0so=";
  };

  cargoHash = "sha256-xmuosy9T/52D90uXMQAIxtaYDOlCekNCtzpu/3GyQXE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libiconv openssl ]
    # Use a newer SDK for CoreFoundation, because the sysinfo crate requires
    # it, https://github.com/GuillaumeGomez/sysinfo/issues/915
    ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk_11_0.frameworks;
      [ IOKit
        CoreFoundation
      ]);

  meta = with lib; {
    description = "Check the health of your Nix setup";
    homepage = "https://zero-to-flakes.com/health/";
    license = licenses.asl20;
    maintainers = with maintainers; [ srid ];
    mainProgram = "nix-health";
  };
}
