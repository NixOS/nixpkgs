{ lib, buildGoModule, fetchFromGitHub, makeWrapper, xdg_utils, installShellFiles, git }:

buildGoModule rec {
  pname = "lab";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "zaquestion";
    repo = "lab";
    rev = "v${version}";
    sha256 = "1l6xsikd1113qd4y0mvjsl64gbi4327m9v4d593f27fxink39j8s";
  };

  subPackages = [ "." ];

  vendorSha256 = "07zl5xhzgrgr5skba6cds5nal58pllf10gak0ap62j1k9gk2ych2";

  doCheck = false;

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  postInstall = ''
    wrapProgram $out/bin/lab --prefix PATH ":" "${lib.makeBinPath [ git xdg_utils ]}";
    for shell in bash fish zsh; do
      $out/bin/lab completion $shell > lab.$shell
      installShellCompletion lab.$shell
    done
  '';

  meta = with lib; {
    description = "Lab wraps Git or Hub, making it simple to clone, fork, and interact with repositories on GitLab";
    homepage = "https://zaquestion.github.io/lab";
    license = licenses.cc0;
    maintainers = with maintainers; [ marsam dtzWill ];
  };
}
