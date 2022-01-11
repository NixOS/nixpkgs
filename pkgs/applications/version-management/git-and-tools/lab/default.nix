{ lib, buildGoModule, fetchFromGitHub, makeWrapper, xdg-utils, installShellFiles, git }:

buildGoModule rec {
  pname = "lab";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "zaquestion";
    repo = "lab";
    rev = "v${version}";
    sha256 = "0g8v3cli8rvr0zsxiv4w0afzqmh0d85a832c4hc75b3f9amkr0dl";
  };

  subPackages = [ "." ];

  vendorSha256 = "09xn5vycb9shygs13pfwxlb89j6rhrbplm10mfgxi4kzlvm7agl6";

  doCheck = false;

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

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
