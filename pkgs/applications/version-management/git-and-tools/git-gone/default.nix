{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, makeWrapper, openssl, git, libiconv, Security, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "lunaryorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zc4cb1dg30np5yc4ymkr894qs2bk0r123i302md00niayk4njyd";
  };

  cargoSha256 = "1d892889ml7sqyxzmjipq5fvizb4abqhmmn450qm7yam9fn5q5wf";

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
