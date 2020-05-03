{ stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-trim";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "foriequal0";
    repo = pname;
    rev = "v${version}";
    sha256 = "06wni47s8yq274bh5f7bcy0sah23938kjiw5pdxnma5kwwnrccrr";
  };

  cargoSha256 = "06ndja8212xy4rybh1117wijsyj70w4z8h6km538a7598s49vzdk";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  postInstall = ''
    install -Dm644 -t $out/share/man/man1/ docs/git-trim.1
  '';

  # fails with sandbox
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Automatically trims your branches whose tracking remote refs are merged or gone";
    homepage = "https://github.com/foriequal0/git-trim";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
