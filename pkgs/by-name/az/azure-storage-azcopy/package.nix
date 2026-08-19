{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "azure-storage-azcopy";
  version = "10.32.6";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BTbPye3ATHqALvVgEhlMKsKbAVxy61FMVPOhHkFaubI=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-adSxTxf38E9ttVcBXECUXJmMTZRQwG6Tq3rsTWh3rhc=";

  doCheck = false;

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = {
    description = "New Azure Storage data transfer utility - AzCopy v10";
    homepage = "https://github.com/Azure/azure-storage-azcopy";
    changelog = "https://github.com/Azure/azure-storage-azcopy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kashw2 ];
  };
})
