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
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/w2BenBIzhD0KHtELlFy7YGv0lykHrjrROZeW75gHis=";
  };

  vendorHash = "sha256-+Q72DUKLqahgbLCaXOTAYZaMvNfv3XF+SpyqHyB065g=";

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
