{ lib
, buildGo121Module
, fetchFromGitHub
, installShellFiles
}:

buildGo121Module rec {
  pname = "k0sctl";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "k0sproject";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-j+FSXW9HGZdirBsCDXOE505y2UA2F3Q1oxZNmgALwc8=";
  };

  vendorHash = "sha256-DrjYqFbPyhjWGJomhPci/EsPOUJPATM0lWqIKbsH6Eg=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k0sproject/k0sctl/version.Environment=production"
    "-X github.com/carlmjohnson/versioninfo.Version=v${version}" # Doesn't work currently: https://github.com/carlmjohnson/versioninfo/discussions/12
    "-X github.com/carlmjohnson/versioninfo.Revision=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash zsh fish; do
      installShellCompletion --cmd ${pname} \
        --$shell <($out/bin/${pname} completion --shell $shell)
    done
  '';

  meta = with lib; {
    description = "A bootstrapping and management tool for k0s clusters.";
    homepage = "https://k0sproject.io/";
    license = licenses.asl20;
    mainProgram = "k0sctl";
    maintainers = with maintainers; [ nickcao qjoly ];
  };
}
