{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "flytectl";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "flyteorg";
    repo = "flytectl";
    rev = "flytectl/${version}";
    hash = "sha256-po7mAsGPUkCupo+WNHfAKlU/ko63NrTfx72pRs3q4bQ=";
  };
  # as by default HOME is a dummy directory
  postBuild = ''
    export HOME=$(pwd)
  '';

  vendorHash = "sha256-g6YtayaXntIhtPvKfbNlL08f6yL4u3hU8ZRyeSSD00I=";
  sourceRoot = "${src.name}/flytectl";

  meta = with lib; {
    description = "Command-line Interface for Flyte";
    homepage = "https://github.com/flyteorg/flyte";
    license = licenses.asl20;
    maintainers = [ maintainers.kdhingra307 ];
    mainProgram = "flytectl";
  };
}
