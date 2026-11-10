{
  lib,
  buildGoModule,
  fetchFromGitHub,
  file,
  installShellFiles,
  asciidoctor,
}:

buildGoModule (finalAttrs: {
  pname = "pistol";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = "pistol";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8ZoGGb2/jfRpeEaSKZtPdd+vsTBSvtOQ2U5nBo1EyAs=";
  };

  vendorHash = "sha256-1+kt6SUqy/acMEJJhWjuC8nnU7UT/7BkmZ25prHpjnM=";

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
    make manpage
    installManPage pistol.1
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "General purpose file previewer designed for Ranger, Lf to make scope.sh redundant";
    homepage = "https://github.com/doronbehar/pistol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "pistol";
  };
})
