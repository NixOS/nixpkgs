{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "genact";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hc4jwk5rr1yw3pfvriash7b03j181k8c9y7m3sglkk8xnff219c";
  };

  cargoSha256 = "0a5ic6c7fvmg2kh3qprzffnpw40cmrgbscrlhxxs3m7nxfjdh7bc";

  meta = with lib; {
    description = "A nonsense activity generator";
    homepage = "https://github.com/svenstaro/genact";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
