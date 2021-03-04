{ lib, buildGoModule, fetchFromGitHub, makeWrapper, xdg-utils, installShellFiles, git }:

buildGoModule rec {
  pname = "lab";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "zaquestion";
    repo = "lab";
    rev = "v${version}";
    sha256 = "sha256-EQqbWM/4CInFNndfD+k7embPUFLXgxRT44e/+Ik2TDs=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-T6kGhje3K2HnR8xRuio6AsYbSwIdbWvAk3ZSnbm1NsA=";

  doCheck = false;

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  postInstall = ''
    wrapProgram $out/bin/lab --prefix PATH ":" "${lib.makeBinPath [ git xdg-utils ]}";
    for shell in bash fish zsh; do
      $out/bin/lab completion $shell > lab.$shell
      installShellCompletion lab.$shell
    done
  '';

  meta = with lib; {
    description = "Lab wraps Git or Hub, making it simple to clone, fork, and interact with repositories on GitLab";
    homepage = "https://zaquestion.github.io/lab";
    license = licenses.cc0;
    maintainers = with maintainers; [ marsam dtzWill SuperSandro2000 ];
  };
}
