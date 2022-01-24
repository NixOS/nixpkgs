{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, makeWrapper, openssl, git, libiconv, Security, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hhy1yazda9r4n753a5m9jf31fbzmm4v8wvl3pksspj2syglmll8";
  };

  cargoSha256 = "0mbc1742szpxnqqah6q0yhkn4fyyxqzg830bd1vzr07v273wr06r";

  nativeBuildInputs = [ pkg-config makeWrapper installShellFiles ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  postInstall = ''
    installManPage git-gone.1
  '';

  postFixup = ''
    wrapProgram $out/bin/git-gone --prefix PATH : "${lib.makeBinPath [ git ]}"
  '';

  meta = with lib; {
    description = "Cleanup stale Git branches of pull requests";
    homepage = "https://github.com/lunaryorn/git-gone";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.unix;
  };
}
