{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "gitoxide";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "gitoxide";
    rev = "v${version}";
    sha256 = "0sx3z9l9n9qq2zj91pgm7znhxjsj59zvwms3aivfglhawwj3iwyj";
  };

  cargoSha256 = "0ykkh86p4csi0v3pb2idjk94w9m32a34a5qrvna7ml5yz84m8hva";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description =
      "A command-line application for interacting with git repositories";
    homepage = "https://github.com/Byron/gitoxide";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.syberant ];
  };
}
