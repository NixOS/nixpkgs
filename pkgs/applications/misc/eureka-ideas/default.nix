{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "eureka-ideas";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "simeg";
    repo = "eureka";
    rev = "v${version}";
    sha256 = "1qjf8nr7m9igy6h228gm9gnav6pi2rfarbd9bc5fchx4rqy59sp7";
  };

  cargoSha256 = "sha256-QujrFgliH8Mx1ES9KVl+O9UJP+7GDanQ7+z4QJuSOd0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "CLI tool to input and store your ideas without leaving the terminal";
    homepage = "https://github.com/simeg/eureka";
    changelog = "https://github.com/simeg/eureka/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "eureka";
  };
}
