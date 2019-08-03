{ stdenv
, fetchgit
, rustPlatform
, openssl
, pkgconfig
, protobuf
, rustup
}:

rustPlatform.buildRustPackage rec {
  pname = "jormungandr";
  version = "0.3.1";

  src = fetchgit {
    url = "https://github.com/input-output-hk/${pname}";
    rev = "v${version}";
    sha256 = "0ys8sw73c7binxnl79dqi7sxva62bgifbhgyzvvjvmjjdxgq4kfp";
    fetchSubmodules = true;
  };

  cargoSha256 = "0fphjzz78ym15qbka01idnq6vkyf4asrnhrhvxngwc3bifmnj937";

  nativeBuildInputs = [ pkgconfig protobuf rustup ];
  buildInputs = [ openssl ];

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
