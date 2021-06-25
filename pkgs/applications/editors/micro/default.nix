{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "micro";
  version = "2.0.9";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8QtucdamxVwHuuhQhVQuvTNbqY5p97LKSB23617p4ow=";
  };

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/micro" ];

  vendorSha256 = "sha256-bkD125ePdKcVgmNilOMZgUK6A8KWxaBOGKs8AvvIboI=";

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/zyedidia/micro/v2/internal/util.Version=${version} -X github.com/zyedidia/micro/v2/internal/util.CommitHash=${src.rev}" ];

  postInstall = ''
    installManPage assets/packaging/micro.1
    install -Dt $out/share/applications assets/packaging/micro.desktop
  '';

  meta = with lib; {
    homepage = "https://micro-editor.github.io";
    description = "Modern and intuitive terminal-based text editor";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
