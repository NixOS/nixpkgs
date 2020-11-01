{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, makeWrapper, openssl, git, libiconv, Security, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hhy1yazda9r4n753a5m9jf31fbzmm4v8wvl3pksspj2syglmll8";
  };

  cargoSha256 = "1g2jijx8y34lid9qwa26v4svab5v9ki6gn9vcfiy61dqa964c3l9";

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
