{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, makeWrapper, openssl, git, libiconv, Security, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wpmabd5lshsga3dhv1hix7i99f1f82rpl6kjmpi315whg11kki3";
  };

  cargoSha256 = "0ayqsrhy6hpi20gfryhnwl2c1na4nnmzxkp7him104cc07vsdllq";

  nativeBuildInputs = [ pkgconfig makeWrapper installShellFiles ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  postInstall = ''
    installManPage git-gone.1
  '';

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
