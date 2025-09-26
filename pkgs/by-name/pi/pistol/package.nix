{
  lib,
  buildGoModule,
  fetchFromGitHub,
  file,
  installShellFiles,
  asciidoctor,
}:

buildGoModule rec {
  pname = "pistol";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = "pistol";
    rev = "v${version}";
    sha256 = "sha256-cL9hHehajqMIpdD10KYIbNkBt2fiRQkx81m9H3Yd1UY=";
  };

  vendorHash = "sha256-+moQ3qZnWmmGpOXUxyBS3hIETK/ZtRwmvD2tXFf0A3o=";

  doCheck = false;

  subPackages = [ "cmd/pistol" ];

  buildInputs = [
    file
  ];
  nativeBuildInputs = [
    installShellFiles
    asciidoctor
  ];
  postInstall = ''
    asciidoctor -b manpage -d manpage README.adoc
    installManPage pistol.1
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "General purpose file previewer designed for Ranger, Lf to make scope.sh redundant";
    homepage = "https://github.com/doronbehar/pistol";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "pistol";
  };
}
