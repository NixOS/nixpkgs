{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "azure-storage-azcopy";
  version = "10.34.2";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2XGMLtUWWWEFgPhpcwXn2guXYxS4UUZAidx/j1yiCb0=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-lq2BRjlWJSpCqhUuImuJPxj4/u7H89V8/SyZliYsXAA=";

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
