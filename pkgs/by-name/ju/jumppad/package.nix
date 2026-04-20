{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jumppad";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "jumppad-labs";
    repo = "jumppad";
    rev = finalAttrs.version;
    hash = "sha256-Dqwug09ESljbgANQdmRyQCOswGDxOwhkd7yQiLdEh8M=";
  };
  vendorHash = "sha256-5eI41EKgi61dVFAvsgxI2Vk1zrxtVinxYKquKlaSOyQ=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  # Tests require a large variety of tools and resources to run including
  # Kubernetes, Docker, and GCC.
  doCheck = false;

  meta = {
    description = "Tool for building modern cloud native development environments";
    homepage = "https://jumppad.dev";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ cpcloud ];
    mainProgram = "jumppad";
  };
})
