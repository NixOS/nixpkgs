{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "runpodctl";
  version = "1.14.12";

  src = fetchFromGitHub {
    owner = "runpod";
    repo = "runpodctl";
    rev = "v${version}";
    hash = "sha256-T0JFPoaH6UhgPMzo+491EUBmjgko1WXP1erMGKc3N5w=";
  };

  vendorHash = "sha256-SaaHVaN2r3DhUk7sVizhRggYZRujd+e8qbpq0xOVD88=";

  postInstall = ''
    rm $out/bin/docs # remove the docs binary
  '';

  meta = {
    homepage = "https://github.com/runpod/runpodctl";
    description = "CLI tool to automate / manage GPU pods for runpod.io";
    changelog = "https://github.com/runpod/runpodctl/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.georgewhewell ];
    mainProgram = "runpodctl";
  };
}
