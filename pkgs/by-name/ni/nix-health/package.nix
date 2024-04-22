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
  version = "0.3.0";

  src = fetchCrate {
    inherit version;
    pname = "nix_health";
    hash = "sha256-u5ipQnux/ulllfPFyUdeLj7gAf3Vu7KL2Q4uYxtv1q4=";
  };

  cargoHash = "sha256-oTO9V+zGmMgDXrt6w1fB81b+WmK3MRI/eCTNEuVM0hk=";

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
    homepage = "https://github.com/juspay/nix-health";
    license = licenses.asl20;
    maintainers = with maintainers; [ srid shivaraj-bh ];
    mainProgram = "nix-health";
  };
}
