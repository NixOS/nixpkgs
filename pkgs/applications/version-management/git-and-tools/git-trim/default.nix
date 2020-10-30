{ stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-trim";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "foriequal0";
    repo = pname;
    rev = "v${version}";
    sha256 = "0w6qrr53wal4p4jvz35f9mpqwz1vfcymj17sz418n9p9lw45f24n";
  };

  cargoSha256 = "1mlvkvgcln59bi249z87v8i0ixq1a7walkzsjml6d219rmy5550h";

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
