{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "azure-storage-azcopy";
  version = "10.32.1";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-clGwRbl/9eLioS2aOqpGV8XrNI+DtIIuwazg2T8b/io=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-Z9RAPIdCM5u30mpe5ozafse7ebUYiR8b0X6tqenXNvA=";

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
