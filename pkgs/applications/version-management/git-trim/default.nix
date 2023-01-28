{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-trim";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "foriequal0";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XAO3Qg5I2lYZVNx4+Z5jKHRIFdNwBJsUQwJXFb4CbvM=";
  };

  cargoHash = "sha256-KCLMb8NXxjscrmKXkP/RbV+LsJqOG7zaClJGFiQ4o9k=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  postInstall = ''
    install -Dm644 -t $out/share/man/man1/ docs/git-trim.1
  '';

  # fails with sandbox
  doCheck = false;

  meta = with lib; {
    description = "Automatically trims your branches whose tracking remote refs are merged or gone";
    homepage = "https://github.com/foriequal0/git-trim";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
