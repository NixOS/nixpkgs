{
  fetchFromGitHub,
  lib,
  nixosTests,
  rustPlatform,
  openssl,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "agnos";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "krtab";
    repo = "agnos";
    rev = "v${version}";
    hash = "sha256-hSiJvpTQIbhz/0AFBTvgfRDTqOi9YcDOvln15SksMJs=";
  };

  cargoHash = "sha256-PuiFzw7TGsTqzLvK5PV8jGBTzvkdh2BKTjeLMOuoUIE=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Obtains certificates from Let's Encrypt using DNS-01 without the need for API access to the DNS provider";
    homepage = "https://github.com/krtab/agnos";
    license = licenses.mit;
    maintainers = with maintainers; [ justinas ];
  };

  passthru.tests = nixosTests.agnos;
}
