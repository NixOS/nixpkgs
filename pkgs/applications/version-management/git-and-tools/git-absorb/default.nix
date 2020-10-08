{ stdenv, fetchFromGitHub, rustPlatform, installShellFiles, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-absorb";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner  = "tummychow";
    repo   = pname;
    rev    = "refs/tags/${version}";
    sha256 = "01hf9hbrigqn4qcz6jmprp7by9nh55k1r2d11g7sil5fpw6m2j9k";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  cargoSha256 = "04dkfjb6pxqaalw2y6yli9q58g8x8ppfmibivpvqifk8r8dhkdqp";

  postInstall = ''
    installManPage Documentation/git-absorb.1
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/tummychow/git-absorb";
    description = "git commit --fixup, but automatic";
    license = [ licenses.bsd3 ];
    maintainers = [ maintainers.marsam ];
  };
}
