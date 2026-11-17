{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "podlet";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podlet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tKgeNVUFjwll4hZHKYJoHpHI0pM4e0ovAaicQj41AHY=";
  };

  cargoHash = "sha256-qV8/HPqQ5/2fiV6BCRQBTW0E3W+LNZsp5wrFuK61+dQ=";

  meta = {
    description = "Generate Podman Quadlet files from a Podman command, compose file, or existing object";
    homepage = "https://github.com/containers/podlet";
    changelog = "https://github.com/containers/podlet/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = [ ];
    mainProgram = "podlet";
  };
})
