{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fuse3,
  testers,
  blobfuse,
  nix-update-script,
}:

let
  version = "2.5.1";
  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-fuse";
    rev = "blobfuse2-${version}";
    sha256 = "sha256-M1BSvuqh9u8G2334gcep9zAvQvJPI6p0q9rLUViimsQ=";
  };
in
buildGoModule {
  pname = "blobfuse";
  inherit version src;

  vendorHash = "sha256-JFR7f06137oaItVha2L2KpXufmlzkAVMq+mNDX7K6XA=";

  buildInputs = [ fuse3 ];

  # Many tests depend on network or needs to be configured to pass. See the link below for a starting point
  # https://github.com/NixOS/nixpkgs/pull/201196/files#diff-e669dbe391f8856f4564f26023fe147a7b720aeefe6869ab7a218f02a8247302R20
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = blobfuse; };
  };

  meta = {
    description = "Mount an Azure Blob storage as filesystem through FUSE";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jbgi ];
    platforms = lib.platforms.linux;
    mainProgram = "azure-storage-fuse";
  };
}
