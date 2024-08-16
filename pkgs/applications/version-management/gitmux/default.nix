{ fetchFromGitHub, buildGoModule, lib, testers, gitmux, git }:

buildGoModule rec {
  pname = "gitmux";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "arl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0Cw98hTg8qPu7BUTBDEgFBOpoCxstPW9HeNXQUUjgGA=";
  };

  vendorHash = "sha256-PHY020MIuLlC1LqNGyBJRNd7J+SzoHbNMPAil7CKP/M=";

  nativeCheckInputs = [ git ];
  doCheck = true;

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
