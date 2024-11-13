{ lib, stdenv, fetchFromGitHub, rustPlatform, darwin, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "pazi";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "euank";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PDgk6VQ/J9vkFJ0N+BH9LqHOXRYM+a+WhRz8QeLZGiM=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  cargoHash = "sha256-7ChHYcyzRPFkZ+zh9lBOHcOizDvJf2cp9ULoI7Ofmqk=";

  postInstall = ''
    installManPage packaging/man/pazi.1
  '';

  meta = with lib; {
    description = "Autojump \"zap to directory\" helper";
    homepage = "https://github.com/euank/pazi";
    license = licenses.gpl3;
    maintainers = [ ];
    mainProgram = "pazi";
  };
}
