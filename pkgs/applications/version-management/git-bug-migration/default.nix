{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-bug-migration";
  version = "v0.3.4"; # the `rev` below pins the version of the source to get
  rev = "e8931156bcbdef8515470d1e18c12391335a235a";

  src = fetchFromGitHub {
    inherit rev;
    owner = "MichaelMure";
    repo = "git-bug-migration";
    sha256 = "1m2dbmxm7ijibsa3vsr3al776hi8c0ajsz8cvg1r3lf29nnn1q10";
  };

  vendorSha256 = "sha256-Hid9OK91LNjLmDHam0ZlrVQopVOsqbZ+BH2rfQi5lS0=";

  doCheck = false;

  ldflags = [
    "-X github.com/MichaelMure/git-bug-migration/commands.GitCommit=${rev}"
    "-X github.com/MichaelMure/git-bug-migration/commands.GitLastTag=${version}"
    "-X github.com/MichaelMure/git-bug-migration/commands.GitExactTag=${version}"
  ];

  postInstall = ''
  '';

  meta = with lib; {
    description = "Migration tool for git-bug, to break things and move forward";
    homepage = "https://github.com/MichaelMure/git-bug-migration";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ royneary ];
  };
}
