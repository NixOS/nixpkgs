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
  version = "2.5.3";
  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-fuse";
    rev = "blobfuse2-${version}";
    sha256 = "sha256-PgpXlyFo+rE32wZfjx7h11YmNka4q/6Jbr03CsW0pZc=";
  };
in
buildGoModule {
  pname = "blobfuse";
  inherit version src;

  vendorHash = "sha256-I2/0BzT9KiMBpzReSll0dKY0uzULRx49fcVGD/z4BPQ=";

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
