{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "azure-storage-azcopy";
  version = "10.32.8";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BAvDjobY54+1lxgBkeu82KHJsf7UoKVN37JM9lFXut0=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-dqjayduNW43OuORg027Mnq1RIgJyeC7JM487Mrgu9Bo=";

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
