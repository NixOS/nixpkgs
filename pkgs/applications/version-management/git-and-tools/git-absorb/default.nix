{ stdenv, fetchFromGitHub, rustPlatform, installShellFiles, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-absorb";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner  = "tummychow";
    repo   = pname;
    rev    = "refs/tags/${version}";
    sha256 = "1xjs5yjb0wj0nf3k3mpgh3hm16544gq7954k1y2r5lwammp0fsxk";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  cargoSha256 = "194ic3f60gpx35rs665vrnjsc3047f0msx1qp797xsz6pg0jx1zq";

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
