{ stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-trim";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "foriequal0";
    repo = pname;
    rev = "v${version}";
    sha256 = "079kavm3n776wvmy25jq1g4qdvmhh3d3x1vdpb1f6pw5rkky8lyw";
  };

  cargoSha256 = "1ii5l7z9avg0gzlaav2gnfbr8wkbp008i5rz6k6bs2sfqnpnn5k6";

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
