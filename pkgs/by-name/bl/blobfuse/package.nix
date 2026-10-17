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
  version = "2.5.5";
  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-fuse";
    rev = "blobfuse2-${version}";
    sha256 = "sha256-P68vhxvG/3fOMJeNxf2LS2GJDnojswm/dl6QLDXpiLA=";
  };
in
buildGoModule {
  pname = "blobfuse";
  inherit version src;

  vendorHash = "sha256-Qm4kKatlQHyYxLFVHuF8w0/sa4iA6Two6rzvcBJqbfU=";

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
    homepage = "https://github.com/Azure/azure-storage-fuse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jbgi ];
    platforms = lib.platforms.linux;
    mainProgram = "azure-storage-fuse";
  };
}
