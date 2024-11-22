{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "runpodctl";
  version = "1.14.4";

  src = fetchFromGitHub {
    owner = "runpod";
    repo = "runpodctl";
    rev = "v${version}";
    hash = "sha256-QU2gujECzT5mPkZi6siMO7IZRXNZHS0TchYxnG4Snj8=";
  };

  vendorHash = "sha256-8/OrM8zrisAfZdeo6FGP6+quKMwjxel1BaRIY+yJq5E=";

  postInstall = ''
    rm $out/bin/docs # remove the docs binary
  '';

  meta = with lib; {
    homepage = "https://github.com/runpod/runpodctl";
    description = "CLI tool to automate / manage GPU pods for runpod.io";
    changelog = "https://github.com/runpod/runpodctl/raw/v${version}/CHANGELOG.md";
    license = licenses.gpl3;
    maintainers = [ maintainers.georgewhewell ];
    mainProgram = "runpodctl";
  };
}
