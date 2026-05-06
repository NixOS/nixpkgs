{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "azure-storage-azcopy";
  version = "10.32.3";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5IBnL8pz4kBo1reJbZKghWa9uHlmn5uK7lXgcZ5h/II=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-ZSnuIx9c3bgzF0HJd1V8HEt5Ia0ZQyQNGEZNwKOKWCc=";

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
