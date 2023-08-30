{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cfdyndns";
  version = "0.0.5";
  src = fetchFromGitHub {
    owner = "colemickens";
    repo = "cfdyndns";
    rev = "v${version}";
    hash = "sha256-oaoUnl5cdOtgVXRYZURoeYSCSWyN/emTg6jcu7BIIGg=";
  };

  cargoHash = "sha256-4vCvWTL9GV9tcoq5YfziPUBBgdt4cPA2/ekOlP8EkNA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "CloudFlare Dynamic DNS Client";
    homepage = "https://github.com/colemickens/cfdyndns";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ colemickens ];
    platforms = with platforms; linux;
  };
}
