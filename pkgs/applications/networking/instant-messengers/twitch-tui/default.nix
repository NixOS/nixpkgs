{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "twitch-tui";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Xithrius";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4gEE2JCYNxPOV47w/wMRvYn5YJdgvlYl+fkk6qcXLr8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  cargoHash = "sha256-IYk01mueNZu791LPdkB79VaxsFXZbqEFDbpw1ckYTMo=";

  meta = with lib; {
    description = "Twitch chat in the terminal";
    homepage = "https://github.com/Xithrius/twitch-tui";
    license = licenses.mit;
    maintainers = [ maintainers.taha ];
  };
}
