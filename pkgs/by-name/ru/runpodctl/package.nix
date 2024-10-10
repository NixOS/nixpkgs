{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "runpodctl";
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "runpod";
    repo = "runpodctl";
    rev = "v${version}";
    hash = "sha256-eemg8W8kTjT9k3TKi+pqRisoxD+7KjetZoWFWbpHFV8=";
  };

  vendorHash = "sha256-9UkHYeDTZlEKEBfazj7N7QJrWcvVi5StxtYE70OF8tw=";

  postInstall = ''
    rm $out/bin/docs # remove the docs binary
    mv $out/bin/cli $out/bin/runpodctl
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

