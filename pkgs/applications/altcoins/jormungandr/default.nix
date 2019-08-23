{ stdenv
, lib
, fetchgit
, rustPlatform
, openssl
, pkgconfig
, protobuf
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "jormungandr";
  version = "0.3.3";

  src = fetchgit {
    url = "https://github.com/input-output-hk/${pname}";
    rev = "v${version}";
    sha256 = "1fw3cl2rxnw9mww1b1z96x2iapwbpdgyp4ra19dhvfzmlvaiml5j";
    fetchSubmodules = true;
  };

  cargoSha256 = "1ilp9ffaz3njv38mnqics4b5d7wh52mj4rwi71h5c0wzx4ww3zal";

  nativeBuildInputs = [ pkgconfig protobuf ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  PROTOC = "${protobuf}/bin/protoc";

  # Disabling integration tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An aspiring blockchain node";
    homepage = "https://input-output-hk.github.io/jormungandr/";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.all;
  };
}
