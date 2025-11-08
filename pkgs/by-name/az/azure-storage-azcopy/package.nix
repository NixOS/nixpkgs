{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.31.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    tag = "v${version}";
    hash = "sha256-5ZnQhaQScTK+jeoshwhheVF6//Jiosu7vMfi8s7bQJw=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-KhlFWo0MuukOtn95T/2ppw21fiGHrcV7CA7RYqK7frs=";

  doCheck = false;

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = {
    description = "New Azure Storage data transfer utility - AzCopy v10";
    homepage = "https://github.com/Azure/azure-storage-azcopy";
    changelog = "https://github.com/Azure/azure-storage-azcopy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kashw2 ];
  };
}
