{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "twitch-tui";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Xithrius";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-144yn/QQPIZJOgqKFUWjB7KCmEKfNpj6XjMGhTpQdEQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoHash = "sha256-zUeI01EyXsuoKzHbpVu3jyA3H2aBk6wMY+GW3h3v8vc=";

  meta = with lib; {
    description = "Twitch chat in the terminal";
    homepage = "https://github.com/Xithrius/twitch-tui";
    license = licenses.mit;
    maintainers = [ maintainers.taha ];
  };
}
