{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "podlet";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podlet";
    rev = "refs/tags/v${version}";
    hash = "sha256-STkYCaXBoQSmFKpMdsKzqFGXHh9s0jeGi5K2itj8jmc=";
  };

  cargoHash = "sha256-G+X9b4PAQ+1TkzGIs1g+qz7HYjwPJ/CvaHMiOAn3dV8=";

  meta = {
    description = "Generate Podman Quadlet files from a Podman command, compose file, or existing object";
    homepage = "https://github.com/containers/podlet";
    changelog = "https://github.com/containers/podlet/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ qwqawawow ];
    mainProgram = "podlet";
  };
}
