{ stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-trim";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "foriequal0";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gfmv9bwhh6bv0s9kfbxq9wsvrk3zz3ibavbpp9l8cpqc3145pqy";
  };

  cargoSha256 = "0xklczk4vbh2mqf76r3rsfyclyza9imf6yss7vbkm9w4ir3ar9f3";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  postInstall = ''
    install -Dm644 docs/git-trim.md.1 $out/share/man/man1/git-trim.1
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
