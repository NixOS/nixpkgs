{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "podlet";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podlet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9hZ0JggtLgLpWQXTCNI4+loyGIzh2l9pbrCjI41hNuA=";
  };

  cargoHash = "sha256-WYOddpFgD41TpkBXWbzSarfIWRIBR9W+RwkZczkn0sQ=";

  meta = {
    description = "Generate Podman Quadlet files from a Podman command, compose file, or existing object";
    homepage = "https://github.com/containers/podlet";
    changelog = "https://github.com/containers/podlet/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    mainProgram = "podlet";
  };
})
