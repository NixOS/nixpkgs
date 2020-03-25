{ stdenv, buildGoModule, fetchFromGitHub, Security }:

buildGoModule rec {
  pname = "git-subtrac";
  version = "0.01";

  src = fetchFromGitHub {
    owner = "apenwarr";
    repo = pname;
    rev = "v${version}";
    sha256 = "1w6gd0x1902lzpqr74gsdrnxq36f6v14bv8h0vhlrfhbwbsih7n6";
  };

  modSha256 = "147vzllp1gydk2156hif313vwykagrj35vaiqy1swqczxs7p9hhs";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Keep the content for your git submodules all in one place: the parent repo";
    homepage = "https://github.com/apenwarr/git-subtrac";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
