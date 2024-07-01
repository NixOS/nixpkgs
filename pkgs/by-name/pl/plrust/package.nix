{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, pkg-config
, zlib
, darwin
, libiconv
, pg16 ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "plrust";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "tcdi";
    repo = "plrust";
    rev = "v${version}";
    hash = "sha256-zHTsMDSXRybFARKTtTldZL35wAVbP8Vhm/zweAswYmo=";
  };

  cargoHash = "sha256-CVZ1YTrdqPBqiYXgVJn+jR1Tny8qlHV4dczF6uVYZyg=";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ zlib ]
    ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional pg16 "pg16";

  meta = with lib; {
    description = "";
    homepage = "";
    license = licenses.mit; # FIXME
    # mainProgram = "plrust?";
    maintainers = with maintainers; [ cafkafk ];
    platforms = platforms.unix ++ platforms.windows; # FIXME
  };
}
