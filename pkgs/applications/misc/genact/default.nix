{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "genact";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sKFI7r0mwmzKiHy9HmskS10M5v/jZj/VeO4F9ZQl2g0=";
  };

  cargoSha256 = "sha256-79IC51xdkelgsRJF+rz9UOTfrJ/HS6PbkyxySe0Qk4Q=";

  meta = with lib; {
    description = "A nonsense activity generator";
    homepage = "https://github.com/svenstaro/genact";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
