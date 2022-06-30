{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, lima
, makeWrapper
, qemu
}:

buildGoModule rec {
  pname = "colima";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "abiosoft";
    repo = pname;
    rev = "v${version}";
    sha256 = "tieQOqcbTT6ODUEcLLwWUD7tDOAb6mklbUecjeVjhRc=";
    # We need the git revision
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git-revision
      rm -rf $out/.git
    '';
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  vendorSha256 = "jDzDwK7qA9lKP8CfkKzfooPDrHuHI4OpiLXmX9vOpOg=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/abiosoft/colima/config.appVersion=${version}"
  ];

  preBuild = ''
    ldflags+=" -X github.com/abiosoft/colima/config.revision=$(cat .git-revision)"
  '';

  subPackages = [ "cmd/colima" ];

  postInstall = ''
    wrapProgram $out/bin/colima \
      --prefix PATH : ${lib.makeBinPath [ lima qemu ]}

    installShellCompletion --cmd colima \
      --bash <($out/bin/colima completion bash) \
      --fish <($out/bin/colima completion fish) \
      --zsh <($out/bin/colima completion zsh)
  '';

  meta = with lib; {
    description = "Container runtimes on MacOS (and Linux) with minimal setup";
    homepage = "https://github.com/abiosoft/colima";
    license = licenses.mit;
    maintainers = with maintainers; [ aaschmid tricktron ];
  };
}
