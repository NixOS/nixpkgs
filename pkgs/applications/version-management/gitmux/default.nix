{ fetchFromGitHub, buildGoModule, lib, testers, gitmux }:

buildGoModule rec {
  pname = "gitmux";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "arl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BvjBEhu6696DkT4GEg2gYTovZEnRosnBD3kzym536e0=";
  };

  vendorHash = "sha256-PHY020MIuLlC1LqNGyBJRNd7J+SzoHbNMPAil7CKP/M=";

  # GitHub source does contain a regression test for the module
  # but it requires networking as it git clones a repo from github
  doCheck = false;

  ldflags = [ "-X main.version=${version}" ];

  passthru.tests.version = testers.testVersion {
    package = gitmux;
    command = "gitmux -V";
  };

  subPackages = [ "." ];

  meta = with lib; {
    description = "Git in your tmux status bar";
    homepage = "https://github.com/arl/gitmux";
    license = licenses.mit;
    maintainers = with maintainers; [ nialov ];
    mainProgram = "gitmux";
  };
}
