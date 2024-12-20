{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fuse3,
  testers,
  blobfuse,
}:

let
  version = "2.1.2";
  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-fuse";
    rev = "blobfuse2-${version}";
    sha256 = "sha256-KzpD+6g1WwviydYE0v5pSH35zC41MrPlk5MitwAIgnE=";
  };
in
buildGoModule {
  pname = "blobfuse";
  inherit version src;

  vendorHash = "sha256-+Z+mkTs/8qCtYcWZIMzsW9MQsC08KDJUHNbxyc6Ro5Y=";

  buildInputs = [ fuse3 ];

  # Many tests depend on network or needs to be configured to pass. See the link below for a starting point
  # https://github.com/NixOS/nixpkgs/pull/201196/files#diff-e669dbe391f8856f4564f26023fe147a7b720aeefe6869ab7a218f02a8247302R20
  doCheck = false;

  passthru.tests.version = testers.testVersion { package = blobfuse; };

  meta = with lib; {
    description = "Mount an Azure Blob storage as filesystem through FUSE";
    license = licenses.mit;
    maintainers = with maintainers; [ jbgi ];
    platforms = platforms.linux;
    mainProgram = "azure-storage-fuse";
  };
}
