{ lib, buildGoModule, fetchFromGitHub, glibc, go-md2man, installShellFiles }:

buildGoModule rec {
  pname = "toolbox";
  version = "0.0.99.3";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = version;
    hash = "sha256-9HiWgEtaMypLOwXJ6Xg3grLSZOQ4NInZtcvLPV51YO8=";
  };

  patches = [ ./glibc.patch ];

  vendorHash = "sha256-k79TcC9voQROpJnyZ0RsqxJnBT83W5Z+D+D3HnuQGsI=";

  postPatch = ''
    substituteInPlace src/cmd/create.go --subst-var-by glibc ${glibc}
  '';

  modRoot = "src";

  nativeBuildInputs = [ go-md2man installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/containers/toolbox/pkg/version.currentVersion=${version}"
  ];

  preCheck = "export PATH=$GOPATH/bin:$PATH";

  postInstall = ''
    cd ..
    for d in doc/*.md; do
      go-md2man -in $d -out ''${d%.md}
    done
    installManPage doc/*.[1-9]
    installShellCompletion --bash completion/bash/toolbox
    install profile.d/toolbox.sh -Dt $out/share/profile.d
  '';

  meta = with lib; {
    homepage = "https://containertoolbx.org";
    changelog = "https://github.com/containers/toolbox/releases/tag/${version}";
    description = "Tool for containerized command line environments on Linux";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
