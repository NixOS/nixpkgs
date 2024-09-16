{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, cmake
, libiconv
, openssl
, pkg-config
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "convco";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "convco";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TRuzHcGnvxDMd/XtbSXj4P+72ZL86Z2FgsqmYrKg/Ys=";
  };

  cargoHash = "sha256-mT1bwCp/MdYbyc9IrC9WDmKfD6lfiqVL7TlenddTXt8=";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "Conventional commit cli";
    mainProgram = "convco";
    homepage = "https://github.com/convco/convco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ hoverbear cafkafk ];
  };
}
