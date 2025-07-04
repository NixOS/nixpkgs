{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "git-pr";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "picosh";
    repo = "git-pr";
    rev = "v${version}";
    hash = "sha256-2A2rP7yr8faVoIYAWprr+t7MwDPerhsuOjWWEl1mhXw=";
  };

  vendorHash = "sha256-7aHr5CWZVmhBiuCXaK49zYJXMufCxZBnS917mF0QJlg=";

  subPackages = [
    "cmd/ssh"
    "cmd/web"
  ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/ssh $out/bin/git-ssh
    mv $out/bin/web $out/bin/git-web
  '';

  meta = {
    homepage = "https://pr.pico.sh";
    description = "Simple git collaboration tool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sigmanificient
      jolheiser
    ];
    mainProgram = "git-ssh";
  };
}
