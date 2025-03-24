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
  version = "2.4.1";
  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-fuse";
    rev = "blobfuse2-${version}";
    sha256 = "sha256-QCrBsEh8o4GblCWNcJssm9c6uSQYVs+qrdzfmI9l278=";
  };
in
buildGoModule {
  pname = "blobfuse";
  inherit version src;

  vendorHash = "sha256-ZzpstCTABL9x5NM5tTiWZqOfI+BSKGZfb+ahbFUmcdo=";

  buildInputs = [ fuse3 ];

  # Many tests depend on network or needs to be configured to pass. See the link below for a starting point
  # https://github.com/NixOS/nixpkgs/pull/201196/files#diff-e669dbe391f8856f4564f26023fe147a7b720aeefe6869ab7a218f02a8247302R20
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = blobfuse; };
  };

  meta = with lib; {
    description = "Mount an Azure Blob storage as filesystem through FUSE";
    license = licenses.mit;
    maintainers = with maintainers; [ jbgi ];
    platforms = platforms.linux;
    mainProgram = "azure-storage-fuse";
  };
}
