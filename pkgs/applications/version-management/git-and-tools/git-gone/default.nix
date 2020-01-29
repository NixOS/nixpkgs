{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, makeWrapper, openssl, git, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "05wlng563p9iy0ky3z23a4jakcix887fb45r7j2mk0fp5ykdjmzh";
  };

  cargoSha256 = "1s3v5p6qgz74sh34gvajf453fsgl13sds4v8hz8c6ivipz4hpby2";

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  postFixup = ''
    wrapProgram $out/bin/git-gone --prefix PATH : "${stdenv.lib.makeBinPath [ git ]}"
  '';

  meta = with stdenv.lib; {
    description = "Cleanup stale Git branches of pull requests";
    homepage = "https://github.com/lunaryorn/git-gone";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.unix;
  };
}
